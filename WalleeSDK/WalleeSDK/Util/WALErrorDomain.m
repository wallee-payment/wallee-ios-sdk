//
//  WALErrorDomain.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALErrorDomain.h"

NSString *const WALErrorDomain = @"com.wallee.ios";

@implementation WALErrorHelper

+ (void)populate:(NSError **)error withInvalidCredentialsWithMessage:(NSString *)message {
    if (error) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
        *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorInvalidCredentials userInfo:userInfo];
    }
}

+ (void)populate:(NSError **)error withIllegalStateWithMessage:(NSString *)message {
    if (error) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
        *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorInvalidState userInfo:userInfo];
    }
}

+ (void)populate:(NSError **)error withIllegalArgumentWithMessage:(NSString *)message {
    if (error) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
        *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorInvalidArgument userInfo:userInfo];
    }
}

//MARK - Checks
+ (BOOL)checkArrayType:(id)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error {
    if (![object isKindOfClass:[NSArray class]]) {
        [WALErrorHelper populate:error withIllegalArgumentWithMessage:message];
        return NO;
    }
    return YES;
}
@end
