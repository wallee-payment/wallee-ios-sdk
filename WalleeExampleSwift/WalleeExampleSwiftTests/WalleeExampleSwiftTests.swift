//
//  WalleeExampleSwiftTests.swift
//  WalleeExampleSwiftTests
//
//  Created by Tobias Ballat on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

import XCTest
import Crypto
import WalleeSDK
@testable import WalleeExampleSwift

class WalleeExampleSwiftTests: XCTestCase {

    let USER_ID: UInt = 526
    let HMAC_KEY: String = "R1x818iST62GkGMgkm1zYKQ3N0Y7YiRRFdrycbs7KII="
    let SPACE_ID: UInt = 412

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCredentials() {
        let expectation = self.expectation(description: "Credentials built")
        self.createCredentials(userId: USER_ID,
                spaceId: SPACE_ID,
                macKey: HMAC_KEY,
                completion: { (credentials: WALCredentials?, _: Error?) in
                    XCTAssertNotNil(credentials, "Credentials are nil")
                    expectation.fulfill()
                })
        self.waitForExpectations(timeout: 7.0, handler: { (error: Error?) -> Void in
            if error != nil {
                XCTFail("Credentials Timeout")
            }
        })
    }

    /// Tests correct authMessage creation according to:
    /// https://app-wallee.com/en-us/doc/api/web-service#_example
    func testHMACMessage() {
        let inputString = self.walleeSecureString(macVersion: 1,
                userId: 2481632,
                timestamp: 1425387916,
                method: "GET",
                path: "/space/1/payment/transaction/987/iframe?paymentMeanConfigurationId=123")
        guard let message = inputString.data(using: .utf8) else {
            XCTFail("Could not convert String to data")
            return
        }
        let hexString = self.walleeHexRepresentationFromData(data: message)
        let authMessage = "0x31, 0x7c, 0x32, 0x34, 0x38, 0x31, 0x36, 0x33, 0x32, 0x7c, 0x31, 0x34, 0x32, 0x35, 0x33, 0x38, 0x37, 0x39, 0x31, 0x36, 0x7c, 0x47, 0x45, 0x54, 0x7c, 0x2f, 0x73, 0x70, 0x61, 0x63, 0x65, 0x2f, 0x31, 0x2f, 0x70, 0x61, 0x79, 0x6d, 0x65, 0x6e, 0x74, 0x2f, 0x74, 0x72, 0x61, 0x6e, 0x73, 0x61, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x2f, 0x39, 0x38, 0x37, 0x2f, 0x69, 0x66, 0x72, 0x61, 0x6d, 0x65, 0x3f, 0x70, 0x61, 0x79, 0x6d, 0x65, 0x6e, 0x74, 0x4d, 0x65, 0x61, 0x6e, 0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x49, 0x64, 0x3d, 0x31, 0x32, 0x33"
        XCTAssertEqual(hexString, authMessage, "Secure string is not correct.")
    }

    /// Tests correct key transformation according to:
    /// https://app-wallee.com/en-us/doc/api/web-service#_example
    func testHMACKey() {
        let decodedSecret = Data(base64Encoded: "OWOMg2gnaSx1nukAM6SN2vxedfY1yLPONvcTKbhDv7I=",
                options: .ignoreUnknownCharacters)
        let hexKey = self.walleeHexRepresentationFromData(data: decodedSecret)
        let encodedKey = "0x39, 0x63, 0x8c, 0x83, 0x68, 0x27, 0x69, 0x2c, 0x75, 0x9e, 0xe9, 0x00, 0x33, 0xa4, 0x8d, 0xda, 0xfc, 0x5e, 0x75, 0xf6, 0x35, 0xc8, 0xb3, 0xce, 0x36, 0xf7, 0x13, 0x29, 0xb8, 0x43, 0xbf, 0xb2"
        XCTAssertEqual(hexKey, encodedKey, "Encoded key is not correct")
    }

    func testHMACGeneration() {
        let inputString = self.walleeSecureString(macVersion: 1,
                userId: 2481632,
                timestamp: 1425387916,
                method: "GET",
                path: "/space/1/payment/transaction/987/iframe?paymentMeanConfigurationId=123")
        guard let message = inputString.data(using: .utf8),
              let decodedSecret = Data(base64Encoded: "OWOMg2gnaSx1nukAM6SN2vxedfY1yLPONvcTKbhDv7I=",
                      options: .ignoreUnknownCharacters)
                else {
            XCTFail("Could not decode Message / Secret.")
            return
        }

        let hMac = self.walleeMacValueFromMessage(message: message, withKey: decodedSecret)
        let hexMac = walleeHexRepresentationFromData(data: hMac)
        let mac = "0x1c, 0x71, 0x91, 0xd8, 0x34, 0x2a, 0xaa, 0x37, 0x7f, 0x3f, 0x97, 0x06, 0x9d, 0xa5, 0x7c, 0x03, 0x62, 0xbb, 0x69, 0x31, 0x05, 0xa7, 0xed, 0xfd, 0xd6, 0x1e, 0x74, 0x03, 0x26, 0x83, 0xd5, 0x88, 0x70, 0x35, 0xa3, 0xe3, 0xbf, 0x0f, 0xeb, 0xef, 0x4c, 0x11, 0xdf, 0x15, 0x81, 0xe7, 0xd3, 0x53, 0x83, 0x1d, 0xc5, 0x88, 0x04, 0x14, 0x77, 0x2f, 0xaf, 0x2d, 0xef, 0x20, 0xe1, 0x3e, 0x3c, 0x0e"
        XCTAssertEqual(hexMac, mac, "MAC Data is not correct")

        let base64Mac = "HHGR2DQqqjd/P5cGnaV8A2K7aTEFp+391h50AyaD1YhwNaPjvw/r70wR3xWB59NTgx3FiAQUdy+vLe8g4T48Dg=="
        let base64MacCreated = hMac.base64EncodedString()
        XCTAssertEqual(base64MacCreated, base64Mac, "Base64 encoded HMAC is not correct")
    }

    // MARK: Helpers

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

    func walleeSecureString(macVersion: Int, userId: UInt, timestamp: UInt, method: String, path: String) -> String {
        return "\(macVersion)|\(userId)|\(timestamp)|\(method)|\(path)"
    }

    func walleeMacValueFromMessage(message: Data, withKey key: Data) -> Data {
        return HMAC.sign(data: message, algorithm: .sha512, key: key)
    }

    func walleeHexRepresentationFromData(data: Data?) -> String {
        var hexString: String = ""
        guard (data != nil) else {
            return hexString
        }
        var firstbyte = true
        for byte in data! {
            if (!firstbyte) {
                hexString = hexString.appending(", ")
            }
            hexString = hexString.appendingFormat("0x%02x", byte)
            firstbyte = false
        }
        return hexString

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
}
