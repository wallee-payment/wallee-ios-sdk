//
//  WALApiClient.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WALMobileSdkUrl, WALPaymentMethodConfiguration, WALTokenVersion, WALTransaction, WALToken;

typedef void (^WALMobileSdkUrlCompletion)(WALMobileSdkUrl * _Nullable mobileSdkUrl, NSError * _Nullable error);
typedef void (^WALPaymentMethodConfigurationsCompletion)(NSArray<WALPaymentMethodConfiguration *> * _Nullable paymentMethodConfigurations, NSError * _Nullable error);
typedef void (^WALTokenVersionsCompletion)(NSArray<WALTokenVersion *> * _Nullable tokenVersions, NSError * _Nullable error);
typedef void (^WALTransactionCompletion)(WALTransaction * _Nullable transaction, NSError * _Nullable error);

@protocol WALApiClient <NSObject>
- (void)buildMobileSdkUrl:(WALMobileSdkUrlCompletion)completion;
- (void)fetchPaymentMethodConfigurations:(WALPaymentMethodConfigurationsCompletion)completion;
- (void)fetchTokenVersions:(WALTokenVersionsCompletion)completion;
- (void)readTransaction:(WALTransactionCompletion)completion;
- (void)processOneClickToken:(WALToken *)token completion:(WALTransactionCompletion)completion;
@end
NS_ASSUME_NONNULL_END
