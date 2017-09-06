//
//  WALFlowCoordinator+Private.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

// TODO: Remove this file?

#import "WALFlowCoordinator.h"
#import "WALFlowTypes.h"
@protocol WALFlowStateHandler;

@interface WALFlowCoordinator (Private)
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALFlowConfiguration *configuration;
@property (nonatomic, assign) WALFlowState state;
@property (nonatomic, copy) id<WALFlowStateHandler> stateHandler;

@property (nonatomic, strong, readwrite) id<WALPaymentFlowContainer> paymentContainer;

- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration;
NS_ASSUME_NONNULL_END
@end
