//
//  TestCredentialsFetccher.m
//  WalleeExample
//
//  Created by Daniel Schmid on 03.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "TestCredentialsFetcher.h"
#include <CommonCrypto/CommonHMAC.h>

@import WalleeSDK;
/// ExampleFragment
static NSUInteger const USER_ID = 480l;
static NSString *const HMAC_KEY = @"644gZTvd8KR2V+Lf4I9zmSnZVuXxd5YTT2U/CTKXHhk=";
static NSUInteger const SPACE_ID = 316l;

/// Unittests
//static NSUInteger const USER_ID = 526l;
//static NSString *const HMAC_KEY = @"R1x818iST62GkGMgkm1zYKQ3N0Y7YiRRFdrycbs7KII=";
//static NSUInteger const SPACE_ID = 412l;

@implementation TestCredentialsFetcher

- (void)fetchCredentials:(WALCredentialsCallback)receiver {
    [self createCredentials:USER_ID space:SPACE_ID macKey:HMAC_KEY completion:^(WALCredentials * _Nullable credential, NSError * _Nullable error) {
        receiver(credential, error);
    }];
}

// MARK: - Connection
- (void)createCredentials:(NSUInteger)userId space:(NSUInteger)spaceId macKey:(NSString *)mac completion:(void (^)(WALCredentials * _Nullable credential, NSError * _Nullable error))completion {
    __block void (^credentialTask)(NSUInteger) = ^(NSUInteger transactionId) {
        NSURL *credentialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://app-wallee.com/api/transaction/createTransactionCredentials?spaceId=%@&id=%@", @(spaceId), @(transactionId)]];
        NSURLRequest *request = [self requestWith:credentialsUrl method:@"POST" forUser:USER_ID contentType:@"application/json" macKey:HMAC_KEY];
        NSURLSessionTask *credentialTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!data) {
                completion(nil, error);
            }
            NSString *credentialString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *innerError = nil;
            WALCredentials *credentials = [WALCredentials credentialsWithCredentials:credentialString error:&innerError];
            
            completion(credentials, innerError);
        }];
        [credentialTask resume];
    };
    
    NSURL *transactionUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://app-wallee.com/api/transaction/create?spaceId=%@", @(spaceId)]];
    NSMutableURLRequest *request = [self requestWith:transactionUrl method:@"POST" forUser:USER_ID contentType:@"application/json" macKey:HMAC_KEY];
    [request setHTTPBody: [self transactionCreationString]];
    
    NSURLSessionTask *transactionTask =[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!data) {
            completion(nil, error);
            return;
        }
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        NSString *transactionId = json[@"id"];
        
        credentialTask(transactionId.integerValue);
    }];
    
    [transactionTask resume];
}

- (NSMutableURLRequest *)requestWith:(NSURL *)url method:(NSString *)method forUser:(NSUInteger)userId contentType:(NSString *)contentType macKey:(NSString *)macKey {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod:method];
    
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *path = url.query ? [NSString stringWithFormat:@"%@?%@", url.path, url.query] : url.path;
    
    NSString *secureString = [self walleeSecureString:1 userId:userId timestamp:timestamp method:method path:path];
    NSData *secureData = [secureString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *decodedSecret = [[NSData alloc] initWithBase64EncodedString:macKey options:0];
    
    NSData *hMacData = [self walleeMacValueFromMessage:secureData withKey:decodedSecret];
    
    NSString *hMac = [hMacData base64EncodedStringWithOptions:0];
    
    NSDictionary *headerFields = @{@"x-mac-version": @"1",
                                   @"x-mac-userid": [NSString stringWithFormat:@"%@", @(userId)],
                                   @"x-mac-timestamp": [NSString stringWithFormat:@"%li", timestamp],
                                   @"x-mac-value": hMac,
                                   @"Content-Type": contentType};
    [request setAllHTTPHeaderFields:headerFields];

    return request;
}

- (NSData *)transactionCreationString {
    NSString *dataString = @"{\n"
    "  \"currency\" : \"EUR\",\n"
    "  \"customerId\": \"test-customer\", \n"
    "  \"lineItems\" : [ {\n"
    "    \"amountIncludingTax\" : \"11.87\",\n"
    "    \"name\" : \"Barbell Pull Up Bar\",\n"
    "    \"quantity\" : \"1\",\n"
    "    \"shippingRequired\" : \"true\",\n"
    "    \"sku\" : \"barbell-pullup\",\n"
    "    \"type\" : \"PRODUCT\",\n"
    "    \"uniqueId\" : \"barbell-pullup\"\n"
    "  } ],\n"
    "  \"merchantReference\" : \"DEV-2630\"\n"
    "}";
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)walleeSecureString:(NSInteger)macVersion userId:(NSUInteger)userId timestamp:(NSUInteger)timestamp method:(NSString *)method path:(NSString *)path {
    return [NSString stringWithFormat:@"%@|%@|%@|%@|%@", @(macVersion), @(userId), @(timestamp), method, path];
}

- (NSData *)walleeMacValueFromMessage:(NSData *)message withKey:(NSData *)key {
    NSMutableData *hMacOut = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, key.bytes, key.length, message.bytes, message.length, hMacOut.mutableBytes);
    
    return hMacOut;
}

@end
