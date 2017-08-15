//
//  WalleeSDKTests.m
//  WalleeSDKTests
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WALCredentials.h"
#import "WALErrorDomain.h"

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
    NSLog(@"error: %@", error);
    XCTAssertNil(credentials, "Credentials should not be initialized");
    XCTAssertNotNil(error, "NSError should be populated");
}

- (void)testCredentialsInvalid2 {
    NSError *error2 = nil;
    WALCredentials *credentials = [WALCredentials credentialsWithCredentials:@"abc-def-cg" error:&error2];
    NSLog(@"error: %@", error2);
    XCTAssertNil(credentials, "Credentials should not be initialized");
    XCTAssertNotNil(error2, "NSError should be populated");
    XCTAssertEqual(error2.code, WALErrorInvalidCredentials, @"error.code should be InvalidCredentials");
    
}

- (void)testCredentialsValid {
    NSError *error;
    NSTimeInterval validTimestamp = [[NSDate date] timeIntervalSince1970] - 60;
    NSString *validCredentials = [NSString stringWithFormat:@"316-16005-%.0f-c4LUhOqIiFrwEcNU3YAJl4_28x3_b2iQAeqJI7V6yP8-grantedUser419", validTimestamp];
    WALCredentials *credentials = [WALCredentials credentialsWithCredentials:validCredentials error:&error];
    XCTAssertNotNil(credentials, "Credentials should be initialized");
    
}

- (void)testWip {
    WALCredentials *credentials = [[WALCredentials alloc] init];
    
}

@end
