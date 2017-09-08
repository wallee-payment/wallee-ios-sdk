//
//  WALNSURLSessionHelper.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALNSURLSessionHelper : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (nullable id)jsonFromData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response responseError:(NSError * _Nullable )responseError error:(NSError * _Nullable *)error;
+ (BOOL)shouldHandleResponseCode:(NSURLResponse *)response withJson:(NSDictionary *)json error:(NSError **)error;
+ (BOOL)shouldHandleResponseCode:(NSURLResponse *)response;

+ (NSString *)extractMimeType:(NSURLResponse *)response;
NS_ASSUME_NONNULL_END
@end
