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
@property (nonatomic, copy) id<WALViewControllerFactory> viewControllerFactory;


@property (nonatomic, copy) id<WALIconCache> iconCache;
@property (nonatomic, copy) NSArray<id<WALFLowListener>> *listeners;
@property (nonatomic, copy) id<WALIconRequestManager> iconRequestManager;
@property (nonatomic, copy) id<WALApiClient> webServiceApiClient;

- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher;
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
