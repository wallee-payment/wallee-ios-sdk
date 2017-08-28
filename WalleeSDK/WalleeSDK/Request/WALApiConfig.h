//
//  WALApiConfig.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WalleeBaseUrl;
FOUNDATION_EXPORT NSString *const WalleeEndpointBuildMobilUrl;
FOUNDATION_EXPORT NSString *const WalleeEndpointFetchPossiblePaymentMethods;
FOUNDATION_EXPORT NSString *const WalleeEndpointFetchTokenVersion;
FOUNDATION_EXPORT NSString *const WalleeEndpointReadTransaction;
FOUNDATION_EXPORT NSString *const WalleeEndpointPerformOneClickToken;

@interface WALApiConfig : NSObject

@end
