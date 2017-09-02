//
//  WALFlowConfigurationBuilder.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowConfiguration.h"
@class WALCredentialsProvider;
@protocol WALPaymentFlowContainerFactory, WALTokenListViewControllerFactory, WALPaymentFormViewControllerFactory, WALPaymentMethodListViewControllerFactory;
@protocol WALSuccessViewControllerFactory, WALFailureViewControllerFactory, WALAwaitingFinalStateViewControllerFactory;
@protocol WALIconCache, WALFLowListener, WALIconRequestManager, WALApiClient;

/**
 * The builder allows to construct a flow configuration.
 *
 * @note The default @c -init method provides the simplest possible configuration which works out of the
 * box. No further customization is required.
 *
 */
@interface WALFlowConfigurationBuilder : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 @warning `paymentFormViewControllerFactory` must not be `nil`.
 */
@property (nonatomic, copy) id<WALPaymentFlowContainerFactory> paymentFlowContainerFactory;

/**
 @warning `paymentFormViewControllerFactory` must not be `nil`.
 */
@property (nonatomic, copy) id<WALPaymentFormViewControllerFactory> paymentFormViewControllerFactory;
/**
 @warning `tokenListViewControllerFactory` must not be `nil`.
 */
@property (nonatomic, copy) id<WALTokenListViewControllerFactory> tokenListViewControllerFactory;
@property (nonatomic, copy) id<WALPaymentMethodListViewControllerFactory> paymentMethodListViewControllerFactory;
@property (nonatomic, copy) id<WALSuccessViewControllerFactory> successViewControllerFactory;
@property (nonatomic, copy) id<WALFailureViewControllerFactory> failureViewControllerFactory;
@property (nonatomic, copy) id<WALAwaitingFinalStateViewControllerFactory> awaitingFinalStateViewControllerFactory;
@property (nonatomic, copy) id<WALIconCache> iconCache;
@property (nonatomic, copy) NSArray<id<WALFLowListener>> *listeners;
@property (nonatomic, copy) id<WALIconRequestManager> iconRequestManager;
@property (nonatomic, copy) id<WALApiClient> webServiceApiClient;

- (instancetype)initWithCredentialsProvider:(WALCredentialsProvider *)credentialsProvider;
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 Checks if a `WALFLowConfiguration` Object can be created from this Builder

 @see WALFLowConfiguration class
 
 @param error contains the reason why this Builder is invalidx
 @return @c YES if WALFLowConfiguration can be initialized @c NO otherwise
 */
- (BOOL)valid:(NSError * _Nullable *)error;
NS_ASSUME_NONNULL_END
@end
