//
//  TestCredentialsFetcher.swift
//  SwiftPodTest
//
//  Created by Tobias Ballat on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

import Foundation
import WalleeSDK
import Crypto

class TestCredentialsFetcher: NSObject, WALCredentialsFetcher {
    let USER_ID: UInt = 526
    let HMAC_KEY: String = "R1x818iST62GkGMgkm1zYKQ3N0Y7YiRRFdrycbs7KII="
    let SPACE_ID: UInt = 412

    func fetchCredentials(_ receiver: @escaping WALCredentialsCallback) {
        createCredentials(userId: USER_ID, spaceId: SPACE_ID, macKey: HMAC_KEY, completion: receiver)
    }

    func createCredentials(userId: UInt,
                           spaceId: UInt,
                           macKey: String,
                           completion: @escaping (_ credential: WALCredentials?, _ error: Error?) -> Void) {
        let credentialTask = {
            (transactionId: UInt) -> Void in
            let credentialsUrl = URL(string: "https://app-wallee.com/api/transaction/createTransactionCredentials?spaceId=\(spaceId)&id=\(transactionId)")
            let request: URLRequest = self.requestWith(url: credentialsUrl!,
                    method: "POST",
                    forUser: userId,
                    contentType: "application/json",
                    macKey: macKey)
            let innerCredentialTask = URLSession.shared.dataTask(with: request,
                    completionHandler: { (data: Data?, _: URLResponse?, error: Error?) -> Void in
                guard let data = data, let credentialString = String(data: data, encoding: .utf8) else {
                    completion(nil, error)
                    return
                }
                var innerError: NSError? = nil
                let credentials = WALCredentials(credentials: credentialString, error: &innerError)
                completion(credentials, innerError)
            })
            innerCredentialTask.resume()
        }
        let transactionUrl = URL(string: "https://app-wallee.com/api/transaction/create?spaceId=\(spaceId)")
        var request = requestWith(url: transactionUrl!,
                method: "POST",
                forUser: userId,
                contentType: "application/json",
                macKey: macKey)
        request.httpBody = transactionCreationString()

        let transactionTask = URLSession.shared.dataTask(with: request,
                completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(nil, error)
                return
            }
            let statusCode = httpResponse.statusCode

            guard statusCode == 200 else {
                let responseError = NSError(domain: "com.wallee.example", code: statusCode, userInfo: [
                    NSLocalizedDescriptionKey: "Transaction not created. API Status code: \(statusCode)",
                    NSLocalizedFailureReasonErrorKey: String(data: data, encoding: .utf8)!
                ])
                completion(nil, responseError)
                return
            }

            do {
                guard let dict: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                      let transactionId = (dict["id"] as? NSNumber)?.uintValue else {
                    print("json dictionary not parsed")
                    return
                }
                credentialTask(transactionId)
            } catch {
                print("json dictionary not parsed")
            }
        })
        transactionTask.resume()
    }

    func requestWith(url: URL,
                     method: String,
                     forUser userId: UInt,
                     contentType: String,
                     macKey: String) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        request.httpMethod = method

        guard let query = url.query else {
            return request
        }
        let timestamp = UInt(Date().timeIntervalSince1970)
        let path = (url.query != nil) ? "\(url.path)?\(query)" : url.path
        let secureString = walleeSecureString(macVersion: 1,
                userId: userId,
                timestamp: timestamp,
                method: method,
                path: path)
        let secureData = secureString.data(using: .utf8)
        let decodedSecret = Data(base64Encoded: macKey, options: .ignoreUnknownCharacters)
        let hMacData = walleeMacValueFromMessage(message: secureData!, withKey: decodedSecret!)
        let hMac = hMacData.base64EncodedString()
        let headerFields: [String: String] = [
            "x-mac-version": "1",
            "x-mac-userid": "\(userId)",
            "x-mac-timestamp": "\(timestamp)",
            "x-mac-value": hMac,
            "Content-Type": contentType
        ]

        request.allHTTPHeaderFields = headerFields

        return request
    }

    func transactionCreationString() -> Data {
        let dataString = "{\n" +
            "  \"currency\" : \"EUR\",\n" +
            "  \"customerId\": \"test-customer\", \n" +
            "  \"lineItems\" : [ {\n" +
            "    \"amountIncludingTax\" : \"11.87\",\n" +
            "    \"name\" : \"Barbell Pull Up Bar\",\n" +
            "    \"quantity\" : \"1\",\n" +
            "    \"shippingRequired\" : \"true\",\n" +
            "    \"sku\" : \"barbell-pullup\",\n" +
            "    \"type\" : \"PRODUCT\",\n" +
            "    \"uniqueId\" : \"barbell-pullup\"\n" +
            "  } ],\n" +
            "  \"merchantReference\" : \"DEV-2630\"\n" +
            "}"
        return dataString.data(using: .utf8)!
    }

    func walleeSecureString(macVersion: Int, userId: UInt, timestamp: UInt, method: String, path: String) -> String {
        return "\(macVersion)|\(userId)|\(timestamp)|\(method)|\(path)"
    }

    func walleeMacValueFromMessage(message: Data, withKey key: Data) -> Data {
        return  HMAC.sign(data: message, algorithm: .sha512, key: key)
    }
}
