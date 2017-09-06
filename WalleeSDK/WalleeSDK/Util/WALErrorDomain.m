//
//  WALErrorDomain.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALErrorDomain.h"
#import "WALTransaction.h"
#import "WALFlowStateHandler.h"

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

+ (void)populate:(NSError **)error withFailedTransaction:(WALTransaction *)transaction {
    if (error) {
        NSString *failureReason = transaction.userFailureMessage;
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: failureReason?:@"reason missing"};
        *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorTransactionFailure userInfo:userInfo];
    }
}

//MARK - Checks
+ (BOOL)checkState:(id<WALLifeCycleObject> _Nullable)state error:(NSError * _Nullable __autoreleasing *)error {
    if (!state || !state.isValid) {
        NSString *msg = [NSString stringWithFormat:@"Trying to run Action on invalidated StateHandler: %@.", state];
        [WALErrorHelper populate:error withIllegalStateWithMessage:msg];
        return NO;
    }
    return YES;
}

+ (BOOL)checkNotEmpty:(id _Nullable)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error {
    if(!object ||
       ([object respondsToSelector:@selector(length)] && [object length] <= 0)){
        [WALErrorHelper populate:error withIllegalArgumentWithMessage:message];
        return NO;
    }
    return YES;
}

+ (BOOL)checkArrayType:(id)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error {
    if (![object isKindOfClass:[NSArray class]]) {
        [WALErrorHelper populate:error withIllegalArgumentWithMessage:message];
        return NO;
    }
    return YES;
}

+ (BOOL)checkDictionaryType:(id)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error {
    if (![object isKindOfClass:[NSDictionary class]]) {
        [WALErrorHelper populate:error withIllegalArgumentWithMessage:message];
        return NO;
    }
    return YES;
}
@end
