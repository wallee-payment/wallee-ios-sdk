//
//  WALErrorDomain.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTransaction;
@protocol WALLifeCycleObject;

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const WALErrorDomain;

/**
 @typedef WALError

 - WALErrorInvalidCredentials: WALErrorInvalidCredentials description
 - WALErrorTransactionFailure: WALErrorTransactionFailure description
 - WALErrorInvalidState: WALErrorInvalidState description
 - WALErrorInvalidArgument: WALErrorInvalidArgument description
 - WALErrorHTTPError: WALErrorHTTPError description
 */
typedef NS_ENUM(NSUInteger, WALError){
    WALErrorInvalidCredentials  = 100,
    WALErrorTransactionFailure  = 200,
    WALErrorInvalidState        = 300,
    WALErrorInvalidArgument     = 400,
    WALErrorHTTPError     = 900,
};

@interface WALErrorHelper : NSObject
+ (void)populate:(NSError **)error withInvalidCredentialsWithMessage:(NSString *)message;
+ (void)populate:(NSError **)error withIllegalStateWithMessage:(NSString *)message;
+ (void)populate:(NSError **)error withIllegalArgumentWithMessage:(NSString *)message;
+ (void)populate:(NSError **)error withFailedTransaction:(WALTransaction *)transaction;

+ (BOOL)checkState:(id<WALLifeCycleObject> _Nullable)state error:(NSError * _Nullable __autoreleasing *)error;
+ (BOOL)checkNotEmpty:(id _Nullable)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error;
+ (BOOL)checkArrayType:(id)object withMessage:(NSString * _Nullable)message error:(NSError * _Nullable __autoreleasing *)error;
+ (BOOL)checkDictionaryType:(id)object withMessage:(NSString *)message error:(NSError * _Nullable __autoreleasing *)error;
@end

NS_ASSUME_NONNULL_END
