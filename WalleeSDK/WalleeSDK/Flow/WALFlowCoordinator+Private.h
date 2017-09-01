//
//  WALFlowCoordinator+Private.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowCoordinator.h"
#import "WALFlowEnums.h"

@interface WALFlowCoordinator ()
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALFlowConfiguration *configuration;
@property (nonatomic, assign) WALFlowState state;

@property (nonatomic, strong, readwrite) id<WALPaymentFlowContainer> paymentContainer;

- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration;
NS_ASSUME_NONNULL_END
@end
