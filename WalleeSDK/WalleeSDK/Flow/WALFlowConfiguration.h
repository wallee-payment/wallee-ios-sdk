//
//  WALFlowConfiguration.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowConfigurationBuilder;
@protocol WALTokenListViewFactory, WALPaymentFormViewFactory, WALPaymentMethodListViewFactory;
@protocol WALSuccessViewFactory, WALFailureViewFactory, WALAwaitingFinalStateViewFactory;
@protocol WALIconCache, WALFLowListener, WALIconRequestManager, WALApiClient;

@interface WALFlowConfiguration : NSObject
#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) id<WALPaymentFormViewFactory> paymentFormViewFactory;
@property (nonatomic, copy, readonly) id<WALTokenListViewFactory> tokenListViewFactory;
@property (nonatomic, copy, readonly) id<WALPaymentMethodListViewFactory> paymentMethodListViewFactory;
@property (nonatomic, copy, readonly) id<WALSuccessViewFactory> successViewFactory;
@property (nonatomic, copy, readonly) id<WALFailureViewFactory> failureViewFactory;
@property (nonatomic, copy, readonly) id<WALAwaitingFinalStateViewFactory> awaitingFinalStateViewFactory;
@property (nonatomic, copy, readonly) id<WALIconCache> iconCache;
@property (nonatomic, copy, readonly) NSArray<id<WALFLowListener>> *listeners;
@property (nonatomic, copy, readonly) id<WALIconRequestManager> iconRequestManager;
@property (nonatomic, copy, readonly) id<WALApiClient> webServiceApiClient;

+ (instancetype)makeWithBuilder:(void (^)(WALFlowConfigurationBuilder *))buildBlock error:(NSError * _Nullable *)error;
NS_ASSUME_NONNULL_END
@end
