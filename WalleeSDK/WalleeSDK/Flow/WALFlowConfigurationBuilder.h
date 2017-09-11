//
//  WALFlowConfigurationBuilder.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowConfiguration.h"
@protocol WALCredentialsFetcher;
@protocol WALPaymentFlowContainerFactory, WALViewControllerFactory;
@protocol WALIconCache, WALFLowListener, WALApiClient;

/**
 * The builder allows to construct a flow configuration.
 *
 * @note The @c -initWithCredentialsFetcher: @c operationQueue: initializer provides the simplest possible configuration which works out of the
 * box. No further customization is required.
 *
 */
@interface WALFlowConfigurationBuilder : NSObject
NS_ASSUME_NONNULL_BEGIN
/**
 @warning `paymentFormViewControllerFactory` must not be `nil`.
 */
@property (nonatomic, strong) id<WALPaymentFlowContainerFactory> paymentFlowContainerFactory;
/**
 @warning `paymentFormViewControllerFactory` must not be `nil`.
 */
@property (nonatomic, strong) id<WALViewControllerFactory> viewControllerFactory;

@property (nonatomic, strong) id<WALIconCache> iconCache;
@property (nonatomic, weak) id<WALPaymentFlowDelegate> delegate;
@property (nonatomic, strong) id<WALApiClient> webServiceApiClient;

/**
 Initializes a Builder that validates correctly and as such can be used to initialize a PaymentFlow
 uses the designated initializer with a nil @c operationQueue

 @param credentialsFetcher the credentialsFetchr supplied by the implementor of the SDK
 @return a fully initialized and usable Builder object
 */
- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher;

/**
 Initializes a Builder that validates correctly and as such can be used to initialize
 a PaymentFlow

 @param credentialsFetcher the credentialsFetcher supplied by the implementor of the SDK
 @param operationQueue operation queue to be used by the default implementations: @c WALNSURLSessionApiClient 
 and @c WALNSURLIconLoader . When @c nil the @c NSURLSession default queue is used
 @return a fully initialized and usable Builder object
 */
- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher operationQueue:(NSOperationQueue * _Nullable)operationQueue NS_DESIGNATED_INITIALIZER;

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
