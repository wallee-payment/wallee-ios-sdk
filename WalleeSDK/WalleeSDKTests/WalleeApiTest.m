//
//  WalleeApiTest.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALSessionApiClient.h"

static NSString *const TestBaseUrl = @"https://app-wallee.com/api/";

@interface WalleeApiTest : XCTestCase

@end

@implementation WalleeApiTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBuildMobileSdkUrl {
    XCTestExpectation *expectation = [self expectationWithDescription:@"MobileSdkUrl built"];

    WALSessionApiClient *client = [WALSessionApiClient clientWithBaseUrl: TestBaseUrl];
    [client buildMobileSdkUrl];
    
    [self waitForExpectationsWithTimeout:7.0 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail("timeout");
        }
    }];
}

// TODO: create credentials analog android
//

@end
