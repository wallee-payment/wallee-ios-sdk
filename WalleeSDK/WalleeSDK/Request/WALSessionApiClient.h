//
//  WALSessionApiClient.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALMobileSdkUrl, WALCredentials;

NS_ASSUME_NONNULL_BEGIN
@interface WALSessionApiClient : NSObject

+(instancetype)clientWithBaseUrl:(NSString*)baseUrl credentialsProvider:(WALCredentials *)credentialsProvider;
-(void) buildMobileSdkUrl: (void (^)(WALMobileSdkUrl *mobileSdkUrl))completion;
@end

NS_ASSUME_NONNULL_END
