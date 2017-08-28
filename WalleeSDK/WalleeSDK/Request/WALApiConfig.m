//
//  WALApiConfig.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALApiConfig.h"

NSString *const WalleeBaseURL = @"https://app-wallee.com/api/";
NSString *const WalleeEndpointBuildMobilUrl = @"transaction/buildMobileSdkUrlWithCredentials";
NSString *const WalleeEndpointFetchPossiblePaymentMethods = @"transaction/fetchPossiblePaymentMethodsWithCredentials";
NSString *const WalleeEndpointFetchTokenVersion = @"transaction/fetchOneClickTokensWithCredentials";
NSString *const WalleeEndpointReadTransaction = @"transaction/readWithCredentials";
NSString *const WalleeEndpointPerformOneClickToken = @"transaction/processOneClickTokenWithCredentials";

@implementation WALApiConfig

@end
