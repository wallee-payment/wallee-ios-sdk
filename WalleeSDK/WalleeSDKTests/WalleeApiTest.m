//
//  WalleeApiTest.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "WALNSURLSessionApiClient.h"
#import "WALApiClient.h"
#import "WALCredentials.h"
#import "WALMobileSdkUrl.h"
#import "WALPaymentMethodConfiguration.h"

static NSString *const TestBaseUrl = @"https://app-wallee.com/api/";
/// ExampleFragment
//static NSUInteger const USER_ID = 480l;
//static NSString *const HMAC_KEY = @"644gZTvd8KR2V+Lf4I9zmSnZVuXxd5YTT2U/CTKXHhk=";
//static NSUInteger const SPACE_ID = 316l;

/// Unittests
static NSUInteger const USER_ID = 526l;
static NSString *const HMAC_KEY = @"R1x818iST62GkGMgkm1zYKQ3N0Y7YiRRFdrycbs7KII=";
static NSUInteger const SPACE_ID = 412l;

@interface WalleeApiTest : XCTestCase
@property (nonatomic, strong) WALCredentials *credentials;
@end

@implementation WalleeApiTest

- (void)setUp {
    [super setUp];
    if (self.credentials) {
        return;
    }
    
    XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"setup %@", self.name]];
    [self createCredentials:USER_ID space:SPACE_ID macKey:HMAC_KEY completion:^(WALCredentials * _Nullable credential) {
        self.credentials = credential;
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("%@ timeout", expectation);
        }
    }];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBuildMobileSdkUrl {
    XCTestExpectation *expectation = [self expectationWithDescription:@"MobileSdkUrl not built"];

    id<WALApiClient> client = [WALNSURLSessionApiClient clientWithBaseUrl:TestBaseUrl credentialsProvider:self.credentials];
    [client buildMobileSdkUrl:^(WALMobileSdkUrl * _Nullable mobileSdkUrl, NSError * _Nullable error) {
        XCTAssertNotNil(mobileSdkUrl, @"MobileSdk is not created");
        NSString *mobileSdkUrlPrefix = [NSString stringWithFormat:@"https://app-wallee.com/s/%@/payment/transaction/mobile-sdk", @(SPACE_ID)];
        BOOL hasCorrectPrefix = [mobileSdkUrl.url hasPrefix:mobileSdkUrlPrefix];
        XCTAssertTrue(hasCorrectPrefix, @"MobileSdkUrl has not correct prefix");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("MobileSdkUrl timeout");
        }
    }];
}

- (void)testFetchPaymentMethodConfigurations {
    XCTestExpectation *expectation = [self expectationWithDescription:@"PaymentMethodConfigurations not fetched"];
    
    id<WALApiClient> client = [WALNSURLSessionApiClient clientWithBaseUrl:TestBaseUrl credentialsProvider:self.credentials];
    [client fetchPaymentMethodConfigurations:^(NSArray<WALPaymentMethodConfiguration *> * _Nullable paymentMethodConfigurations, NSError * _Nullable error) {
        XCTAssertNotNil(paymentMethodConfigurations, @"paymentMethodConfigurations not created");
        XCTAssertTrue(paymentMethodConfigurations.count > 0, @"The payment methods list is empty");
        XCTAssertEqual([paymentMethodConfigurations firstObject].linkedSpaceId, SPACE_ID, @"The returned SpaceID is not equal to the requested");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("MobileSdkUrl timeout");
        }
    }];
}

- (void)testFetchTokenVersions {
    XCTestExpectation *expectation = [self expectationWithDescription:@"TokenVersions not fetched"];
    
    id<WALApiClient> client = [WALNSURLSessionApiClient clientWithBaseUrl:TestBaseUrl credentialsProvider:self.credentials];
    [client fetchTokenVersions:^(NSArray<WALTokenVersion *> * _Nullable tokenVersions, NSError * _Nullable error) {
        XCTAssertNotNil(tokenVersions, @"paymentMethodConfigurations not created");
        XCTAssertTrue(tokenVersions.count > 0, @"The payment methods list is empty");
//        XCTAssertEqual([tokenVersions firstObject].linkedSpaceId, SPACE_ID, @"The returned SpaceID is not equal to the requested");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("MobileSdkUrl timeout");
        }
    }];
}

- (void)testCredentials {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credentials not built"];
    [self createCredentials:USER_ID space:SPACE_ID macKey:HMAC_KEY completion:^(WALCredentials *credential) {
        XCTAssertNotNil(credential, "Credentials are nil");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("Credentials Timeout");
        }
    }];
}

/// Tests correct authMessage creation according to:
/// https://app-wallee.com/en-us/doc/api/web-service#_example
- (void)testHMACMessage {
    NSString *inputString = [self walleeSecureString:1 userId:2481632 timestamp:1425387916 method:@"GET" path:@"/space/1/payment/transaction/987/iframe?paymentMeanConfigurationId=123"];
    NSData *message = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *hexString = [self walleeHexRepresentationFromData:message];
    NSString *authMessage = @"0x31, 0x7c, 0x32, 0x34, 0x38, 0x31, 0x36, 0x33, 0x32, 0x7c, 0x31, 0x34, 0x32, 0x35, 0x33, 0x38, 0x37, 0x39, 0x31, 0x36, 0x7c, 0x47, 0x45, 0x54, 0x7c, 0x2f, 0x73, 0x70, 0x61, 0x63, 0x65, 0x2f, 0x31, 0x2f, 0x70, 0x61, 0x79, 0x6d, 0x65, 0x6e, 0x74, 0x2f, 0x74, 0x72, 0x61, 0x6e, 0x73, 0x61, 0x63, 0x74, 0x69, 0x6f, 0x6e, 0x2f, 0x39, 0x38, 0x37, 0x2f, 0x69, 0x66, 0x72, 0x61, 0x6d, 0x65, 0x3f, 0x70, 0x61, 0x79, 0x6d, 0x65, 0x6e, 0x74, 0x4d, 0x65, 0x61, 0x6e, 0x43, 0x6f, 0x6e, 0x66, 0x69, 0x67, 0x75, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x49, 0x64, 0x3d, 0x31, 0x32, 0x33";
    XCTAssertEqualObjects(hexString, authMessage, @" secure string is not correct");
}


/// Tests correct key transformation according to:
/// https://app-wallee.com/en-us/doc/api/web-service#_example
- (void)testHMACKey {
    
    NSData *decodedSecret = [[NSData alloc] initWithBase64EncodedString:@"OWOMg2gnaSx1nukAM6SN2vxedfY1yLPONvcTKbhDv7I=" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // [@"OWOMg2gnaSx1nukAM6SN2vxedfY1yLPONvcTKbhDv7I" dataUsingEncoding: NSUTF8StringEncoding];
    //
    NSString *hexKey = [self walleeHexRepresentationFromData:decodedSecret];
    NSString *encodedKey = @"0x39, 0x63, 0x8c, 0x83, 0x68, 0x27, 0x69, 0x2c, 0x75, 0x9e, 0xe9, 0x00, 0x33, 0xa4, 0x8d, 0xda, 0xfc, 0x5e, 0x75, 0xf6, 0x35, 0xc8, 0xb3, 0xce, 0x36, 0xf7, 0x13, 0x29, 0xb8, 0x43, 0xbf, 0xb2";
    XCTAssertEqualObjects(hexKey, encodedKey, " encoded key is not correct");
}

- (void)testHMACGeneration {
    NSString *inputString = [self walleeSecureString:1 userId:2481632 timestamp:1425387916 method:@"GET" path:@"/space/1/payment/transaction/987/iframe?paymentMeanConfigurationId=123"];
    NSData *message = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decodedSecret = [[NSData alloc] initWithBase64EncodedString:@"OWOMg2gnaSx1nukAM6SN2vxedfY1yLPONvcTKbhDv7I=" options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *hMac = [self walleeMacValueFromMessage:message withKey:decodedSecret];
    NSString *hexMac = [self walleeHexRepresentationFromData:hMac];
    
    NSString *mac = @"0x1c, 0x71, 0x91, 0xd8, 0x34, 0x2a, 0xaa, 0x37, 0x7f, 0x3f, 0x97, 0x06, 0x9d, 0xa5, 0x7c, 0x03, 0x62, 0xbb, 0x69, 0x31, 0x05, 0xa7, 0xed, 0xfd, 0xd6, 0x1e, 0x74, 0x03, 0x26, 0x83, 0xd5, 0x88, 0x70, 0x35, 0xa3, 0xe3, 0xbf, 0x0f, 0xeb, 0xef, 0x4c, 0x11, 0xdf, 0x15, 0x81, 0xe7, 0xd3, 0x53, 0x83, 0x1d, 0xc5, 0x88, 0x04, 0x14, 0x77, 0x2f, 0xaf, 0x2d, 0xef, 0x20, 0xe1, 0x3e, 0x3c, 0x0e";
    
    XCTAssertEqualObjects(hexMac, mac, "MAC Data is not correct");
    
    NSString *base64Mac = @"HHGR2DQqqjd/P5cGnaV8A2K7aTEFp+391h50AyaD1YhwNaPjvw/r70wR3xWB59NTgx3FiAQUdy+vLe8g4T48Dg==";
    NSString *base64MacCreated = [hMac base64EncodedStringWithOptions:0];
    
    XCTAssertEqualObjects(base64MacCreated, base64Mac, @"Base64 encoded HMAC is not correct");
}

// MARK: - Helpers

- (void)createCredentials:(NSUInteger)userId space:(NSUInteger)spaceId macKey:(NSString *)mac completion:(void (^)(WALCredentials * _Nullable credential))completion {
    __block void (^credentialTask)(NSUInteger) = ^(NSUInteger transactionId) {
        NSURL *credentialsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://app-wallee.com/api/transaction/createTransactionCredentials?spaceId=%@&id=%@", @(spaceId), @(transactionId)]];
        NSURLRequest *request = [self requestWith:credentialsUrl method:@"POST" forUser:USER_ID contentType:@"application/json" macKey:HMAC_KEY];
        NSURLSessionTask *credentialTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *credentialString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            XCTAssertNotNil(credentialString, @"Credential String is not generated");
            NSError *innerError = nil;
            WALCredentials *credentials = [WALCredentials credentialsWithCredentials:credentialString error:&innerError];
            XCTAssertNil(error, @"Credentials cannot be parsed");
            completion(credentials);
        }];
        [credentialTask resume];
    };
    
    NSURL *transactionUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://app-wallee.com/api/transaction/create?spaceId=%@", @(spaceId)]];
    NSMutableURLRequest *request = [self requestWith:transactionUrl method:@"POST" forUser:USER_ID contentType:@"application/json" macKey:HMAC_KEY];
    [request setHTTPBody: [self transactionCreationString]];
    
    NSURLSessionTask *transactionTask =[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        NSString *transactionId = json[@"id"];
        XCTAssertNotNil(transactionId, "returned transaction id is empty");
        
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

//    NSLog(@" -- headerfields: %@", headerFields);
//    NSLog(@" -- secureString: \n%@", secureString);
//    NSLog(@" -- secureData: \n%@", secureData);
//    NSLog(@" -- secret: \n%@", decodedSecret);
//    NSLog(@" -- Mac: \n%@", hMac);

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

- (NSString *)walleeHexRepresentationFromData:(NSData *)data {
    NSString *hexString = @"";
    if (data) {
        uint8_t *dataPointer = (uint8_t *)(data.bytes);
        for (int i = 0; i < data.length; i++) {
            if (i != 0) {
                hexString = [hexString stringByAppendingString:@", "];
            }
            hexString = [hexString stringByAppendingFormat:@"0x%02x", dataPointer[i]];
        }
    }
    return hexString;
}

- (NSString *)hexFromData:(NSData *)data {
    NSString *hexString = @"";
    if (data) {
        uint8_t *dataPointer = (uint8_t *)(data.bytes);
        for (int i = 0; i < data.length; i++) {
            if (i != 0) {
                hexString = [hexString stringByAppendingString:@", "];
            }
            hexString = [hexString stringByAppendingFormat:@"0x%02x", dataPointer[i]];
        }
    }
    return hexString;
}

@end
