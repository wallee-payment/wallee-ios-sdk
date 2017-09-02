//
//  WALFlowConfiguration.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowConfigurationBuilder;
@protocol WALPaymentFlowContainerFactory;
@protocol WALTokenListViewControllerFactory, WALPaymentFormViewControllerFactory, WALPaymentMethodListViewControllerFactory;
@protocol WALSuccessViewControllerFactory, WALFailureViewControllerFactory, WALAwaitingFinalStateViewControllerFactory;
@protocol WALIconCache, WALPaymentFlowDelegate, WALIconRequestManager, WALApiClient;

/**
 * The flow configuration holds all the configuration which influence the way how the {@link
 * FlowConfiguration} is working.
 *
 * <p>The configuration is immutable and as such it can be passed along different threads.</p>
 * @note use the static @c makeWithbuilder: method to create a configuration since this class
 * relies on the a @c WALFlowConfigurationBuilder to be properly initialized
 */
@interface WALFlowConfiguration : NSObject
#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * The payment flow container factory creates the view which contains all other views and interactions.
 *
 * @return the factory which is used to create the payment flow container.
 */
@property (nonatomic, copy, readonly) id<WALPaymentFlowContainerFactory> paymentFlowContainerFactory;

/**
 * The payment form view factory creates the view which collects the payment information.
 *
 * @return the factory which is used to create the payment form view.
 */
@property (nonatomic, copy, readonly) id<WALPaymentFormViewControllerFactory> paymentFormViewControllerFactory;

/**
 * The token selection view lets the user select a token from a list of tokens. The selected
 * token will be used to process the transaction.
 *
 * @return the factory which is responsible to create teh token selection view.
 */
@property (nonatomic, copy, readonly) id<WALTokenListViewControllerFactory> tokenListViewControllerFactory;

/**
 * The payment method selection view allows the user to select from a list of payment methods
 * the one which should be used to process the transaction with.
 *
 * @return the factory which is responsible for creating the payment method selection view.
 */
@property (nonatomic, copy, readonly) id<WALPaymentMethodListViewControllerFactory> paymentMethodListViewControllerFactory;

/**
 * The success view is displayed once the transaction has been processed successfully.
 *
 * @return the factory which is used to create the success view.
 */
@property (nonatomic, copy, readonly) id<WALSuccessViewControllerFactory> successViewControllerFactory;

/**
 * When the transaction fails the {@link com.wallee.android.sdk.flow.FlowCoordinator} will show
 * a view which explains to the user why the transaction failed. This factory is responsible for
 * this view.
 *
 * @return the factory which is responsible for creating the view for failed transactions.
 */
@property (nonatomic, copy, readonly) id<WALFailureViewControllerFactory> failureViewControllerFactory;

/**
 * The transaction may not reach a final state immediately. In this case the awaiting final
 * state view will be displayed. The returned factory is used to create this view.
 *
 * @return the factory which creates the view for the awaiting final state view.
 */
@property (nonatomic, copy, readonly) id<WALAwaitingFinalStateViewControllerFactory> awaitingFinalStateViewControllerFactory;

/**
 * The icon cache is required to cache the downloaded icons locally on the device to avoid
 * downloading them over and over again.
 *
 * @return the icon cache in which the payment method icons are cached in.
 */
@property (nonatomic, copy, readonly) id<WALIconCache> iconCache;

/**
 * The delegate of this PaymentProcess. It will get informed on all the lifecycle events of this
 * process
 *
 * @return the delegate.
 */
@property (nonatomic, weak, readonly) id<WALPaymentFlowDelegate> delegate;

/**
 * Each payment method has an icon. The icon is configured through the backend of wallee.
 * Therefore the icon is downloaded dynamically. The icon request manager is responsible to
 * manage this download process.
 *
 * @return the icon request manager is used to download the payment method icons from the remote
 * server.
 */
@property (nonatomic, copy, readonly) id<WALIconRequestManager> iconRequestManager;

/**
 * The web service API client allows to access directly the web service API of wallee. This
 * client wraps the API to make it more easy to use with Java.
 *
 * @return the web service API client which is used to connect to the wallee web service.
 */
@property (nonatomic, copy, readonly) id<WALApiClient> webServiceApiClient;


/**
 Use this factory method to create a @c WALFlowConfiguration.
 
 @note For a simple configuration that works out of the box use
 @code
 id builder = [WALFlowConfigurationBuilder initWithCredentialsProvider:provider];
 [WALFlowConfiguration makeWithBuilder:builder];
 @endcode
 
 @param buildBlock use this block to configure your @c WALFlowConfiguration
 @param error will holde information on why a @c WALFlowConfiguration could not be initialized
 @return fully initialized @c WALFlowConfiguration
 */
+ (instancetype)makeWithBlock:(void (^ _Nullable )(WALFlowConfigurationBuilder *))buildBlock error:(NSError * _Nullable *)error;

+ (instancetype)makeWithBuilder:(WALFlowConfigurationBuilder *)buildBlock error:(NSError * _Nullable *)error;

NS_ASSUME_NONNULL_END
@end
