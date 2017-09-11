//
//  WALNSURLSessionApiClient.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALApiClient.h"

@class WALCredentialsProvider;

@interface WALNSURLSessionApiClient : NSObject <WALApiClient>
//#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN
/**
 Returns a fully initialized @c WALApiClient using the default WalleeBaseURL

 @param credentialsProvider the @c WALCredentialsProvider to be used for all requests
 @return fully initialized apiClient
 */
+ (instancetype)clientWithCredentialsProvider:(WALCredentialsProvider *)credentialsProvider operationQueue:(NSOperationQueue *_Nullable)queue;

/**
 returns a @c WALApiClient with custom baseUrl and given credentialsProvider

 @param baseUrl custom baseUrl to the api
 @param credentialsProvider the @c WALCredentialsProvider to be used for all requests
 @param queue the NSOperationQueue for the @c NSURLSession to use. can be @c nil 
 @return fully initialized apiClient
 */
+ (instancetype)clientWithBaseUrl:(NSString*)baseUrl credentialsProvider:(WALCredentialsProvider *)credentialsProvider operationQueue:(NSOperationQueue *_Nullable)queue;
NS_ASSUME_NONNULL_END
@end


