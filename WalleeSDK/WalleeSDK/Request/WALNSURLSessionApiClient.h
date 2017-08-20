//
//  WALNSURLSessionApiClient.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALApiClient.h"

@class WALMobileSdkUrl, WALCredentials;

NS_ASSUME_NONNULL_BEGIN
@interface WALNSURLSessionApiClient : NSObject <WALApiClient>
+ (instancetype)clientWithBaseUrl:(NSString*)baseUrl credentialsProvider:(WALCredentials *)credentialsProvider;
@end

NS_ASSUME_NONNULL_END
