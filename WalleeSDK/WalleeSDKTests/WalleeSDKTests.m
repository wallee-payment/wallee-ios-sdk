//
//  WalleeSDKTests.m
//  WalleeSDKTests
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALCredentialsProvider.h"
#import "WALCredentialsFetcher.h"
#import "WALCredentials.h"
#import "WALMobileSdkUrl.h"
#import "WALErrorDomain.h"
#import "WALTypes.h"
#import "WALTestCredentialFetcher.h"

@interface WalleeSDKTests : XCTestCase

@end

@implementation WalleeSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCredentialsInvalid {
    NSError *error;
    WALCredentials *credentials = [WALCredentials credentialsWithCredentials:@"" error:&error];
//    NSLo g(@"error: %@", error);
    XCTAssertNil(credentials, "Credentials should not be initialized");
    XCTAssertNotNil(error, "NSError should be populated");
}

- (void)testCredentialsInvalid2 {
    NSError *error2 = nil;
    WALCredentials *credentials = [WALCredentials credentialsWithCredentials:@"abc-def-cg" error:&error2];
//    NSLog(@"error: %@", error2);
    XCTAssertNil(credentials, "Credentials should not be initialized");
    XCTAssertNotNil(error2, "NSError should be populated");
    XCTAssertEqual(error2.code, WALErrorInvalidCredentials, @"error.code should be InvalidCredentials");
    
}

- (void)testCredentialsValid {
    NSError *error;
    WALTimestamp validTimestamp = [[NSDate date] timeIntervalSince1970] - 60;
    NSString *validCredentials = [NSString stringWithFormat:@"316-16005-%@-c4LUhOqIiFrwEcNU3YAJl4_28x3_b2iQAeqJI7V6yP8-grantedUser419", @(validTimestamp)];
    WALCredentials *credentials = [WALCredentials credentialsWithCredentials:validCredentials error:&error];
    XCTAssertNotNil(credentials, "Credentials should be initialized");
    
}

- (void)testMobileSdkUrlValid {
    NSError *error;
    WALTimestamp validTimestamp = [[NSDate date] timeIntervalSince1970] + 3*60;
    WALMobileSdkUrl *mobileSdkUrl = [[WALMobileSdkUrl alloc] initWithUrl:@"" expiryDate:validTimestamp];
    NSURL *paymentMethodUrl = [mobileSdkUrl buildPaymentMethodUrl:3 error:&error];
    XCTAssertNotNil(paymentMethodUrl, @"paymentMethod should not be created");
    XCTAssertNil(error, @"paymentMethod error should not be nil");
}

- (void)testMobileSdkUrlInvalid {
    NSError *error;
    WALTimestamp validTimestamp = [[NSDate date] timeIntervalSince1970] - 60;
    WALMobileSdkUrl *mobileSdkUrl = [[WALMobileSdkUrl alloc] initWithUrl:@"" expiryDate:validTimestamp];
    BOOL isExpired = mobileSdkUrl.isExpired;
    XCTAssertTrue(isExpired, @"mobileSdkUrl is not correctly marked as expired");
    NSURL *paymentMethodUrl = [mobileSdkUrl buildPaymentMethodUrl:3 error:&error];
    XCTAssertNil(paymentMethodUrl, @"paymentMethod should be nil");
    XCTAssertNotNil(error, @"paymentMethod error should be populated");
}


@class WALTestCredentialFetcher;
- (void)testCredentialsProviderValid {
    WALTestCredentialFetcher *fetcher = [[WALTestCredentialFetcher alloc] init];
    WALCredentials *protoCredentials = fetcher.credentials;
    WALCredentialsProvider *provider = [[WALCredentialsProvider alloc] initWith:fetcher];
    void(^callbackBlock)(WALCredentials *, NSError *) = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        XCTAssertEqualObjects(protoCredentials, credentials, @"Callback should always receive same credentials");
    };
    
    [provider getCredentials:callbackBlock];
    XCTAssertEqual(1, fetcher.counter, @" WALCredentialsFetcher.fetch should only be called once");
    [NSThread sleepForTimeInterval:1]; // T`is to make sure that the Provider has time to Cache the data (asyncronosity)
    [provider getCredentials:callbackBlock];
    XCTAssertEqual(1, fetcher.counter, @" WALCredentialsFetcher.fetch should only be called once");
}

@end



