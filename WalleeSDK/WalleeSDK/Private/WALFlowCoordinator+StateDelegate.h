//
//  WALFlowCoordinator+StateDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowCoordinator.h"
#import "WALFlowStateDelegate.h"
@protocol WALFlowStateHandler;

@interface WALFlowCoordinator (StateDelegate) <WALFlowStateDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALFlowConfiguration *configuration;
@property (nonatomic, assign) WALFlowState state;
@property (nonatomic, copy) id<WALFlowStateHandler> stateHandler;

@property (nonatomic, strong, readwrite) id<WALPaymentFlowContainer> paymentContainer;
NS_ASSUME_NONNULL_END
@end

