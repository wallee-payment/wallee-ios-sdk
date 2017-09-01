//
//  WALFlowCoordinator.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowEnums.h"

#import "WALFlowCoordinator+Private.h"
#import "WALFlowConfiguration.h"

#import "WALPaymentFlowContainerFactory.h"

@implementation WALFlowCoordinator

- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _state = WALFlowStateTokenLoading;
        // --> state.view to containerFactory
    }
    return self;
}

+ (instancetype)startPaymentWithConfiguration:(WALFlowConfiguration *)configuration {
    if (!configuration) {
        return nil;
    }
    WALFlowCoordinator *coordinator = [[self alloc] initWithConfiguration:configuration];
    return coordinator;
}

- (id<WALPaymentFlowContainer>)paymentContainer {
    if (!_paymentContainer) {
        _paymentContainer = [self.configuration.paymentFlowContainerFactory build]; // TODO: check rootview
    }
    return _paymentContainer;
}

@end
