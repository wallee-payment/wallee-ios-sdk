//
//  WALFlowConfigurationBuilder.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WALTokenListViewFactory, WALPaymentFormViewFactory, WALPaymentMethodListViewFactory;
@protocol WALSuccessViewFactory, WALFailureViewFactory, WALAwaitingFinalStateViewFactory;
@protocol WALIconCache, WALFLowListener, WALIconRequestManager, WALApiClient;

@interface WALFlowConfigurationBuilder : NSObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) id<WALPaymentFormViewFactory> paymentFormViewFactory;
@property (nonatomic, copy) id<WALTokenListViewFactory> tokenListViewFactory;
@property (nonatomic, copy) id<WALPaymentMethodListViewFactory> paymentMethodListViewFactory;
@property (nonatomic, copy) id<WALSuccessViewFactory> successViewFactory;
@property (nonatomic, copy) id<WALFailureViewFactory> failureViewFactory;
@property (nonatomic, copy) id<WALAwaitingFinalStateViewFactory> awaitingFinalStateViewFactory;
@property (nonatomic, copy) id<WALIconCache> iconCache;
@property (nonatomic, copy) NSArray<id<WALFLowListener>> *listeners;
@property (nonatomic, copy) id<WALIconRequestManager> iconRequestManager;
@property (nonatomic, copy) id<WALApiClient> webServiceApiClient;


/**
 Checks if a WALFLowConfiguration Object can be created from this Builder

 @param error contains the reason why this Builder is invalid
 @return @c YES if WALFLowConfiguration can be initialized @c Otherwise
 */
- (BOOL)valid:(NSError * _Nullable *)error;
NS_ASSUME_NONNULL_END
@end
