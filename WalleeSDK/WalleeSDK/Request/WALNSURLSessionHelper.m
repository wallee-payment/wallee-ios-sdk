//
//  WALNSURLSessionHelper.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALNSURLSessionHelper.h"
#import "WALApiConfig.h"
#import "WALApiClientError.h"
#import "WALApiServerError.h"
#import "WALErrorDomain.h"

@implementation WALNSURLSessionHelper

+ (nullable id)jsonFromData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response responseError:(NSError * _Nullable )responseError error:(NSError * _Nullable *)error {
    
    if (data) {
        NSError *jsonError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&jsonError];
        if (!json) {
            if (error) {
                *error = jsonError;
            }
            return nil;
        }
        
        // status codes != 200 are not handled as errors by NSURLConnection
        if (![self shouldHandleResponseCode:response withJson:json error:&jsonError]) {
            if (error) {
                *error = jsonError;
            }
            return nil;
        }
        
        return json;
    } else {
        if (error) {
            *error = responseError;
        }
        return nil;
    }
}

+ (BOOL)shouldHandleResponseCode:(NSURLResponse *)response withJson:(NSDictionary *)json error:(NSError **)error {
    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    if (![self shouldHandleResponseCode:response]) {
        if (error) {
            //TODO: impl? Cilent vs Server Error Classes
            if (statusCode == WalleClientErrorReturnCode) {
                WALApiClientError *clientError = [WALApiClientError decodedObjectFromJSON:json error:error];
                if (clientError) {
                    *error = clientError;
                }
            } else if(statusCode == WalleServerErrorReturnCode) {
                WALApiServerError *serverError = [WALApiServerError decodedObjectFromJSON:json error:error];
                if (serverError) {
                    *error = serverError;
                }
            } else {
                *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorHTTPError userInfo:@{@"statusCode": @(statusCode), @"response": response, @"data": json}];
            }
        }
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)shouldHandleResponseCode:(NSURLResponse *)response {
    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    if (statusCode == 0 || statusCode > 399) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)extractMimeType:(NSURLResponse *)response {
    if (![response isKindOfClass:NSHTTPURLResponse.class]) {
        return nil;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSString *contentType = httpResponse.allHeaderFields[@"Content-Type"];
    return contentType;
}

@end
