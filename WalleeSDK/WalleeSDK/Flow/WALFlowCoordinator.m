//
//  WALFlowCoordinator.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowTypes.h"

#import "WALFlowCoordinator+Private.h"
#import "WALFlowConfiguration.h"

#import "WALPaymentFlowContainerFactory.h"
#import "WALFlowStateHandlerFactory.h"
#import "WALFlowStateHandler.h"


@interface WALFlowCoordinator ()
@property (nonatomic) int isStarted;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation WALFlowCoordinator

- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _state = WALFlowStateTokenLoading;
        _stateHandler = [WALFlowStateHandlerFactory handlerFromState:_state stateParameters:nil];
        // --> state.view to containerFactory
    }
    return self;
}

+ (instancetype)paymentFlowWithConfiguration:(WALFlowConfiguration *)configuration {
    if (!configuration) {
        return nil;
    }
    WALFlowCoordinator *coordinator = [[self alloc] initWithConfiguration:configuration];
    return coordinator;
}

- (void)start {
    @synchronized (self) {
        if (!self.isStarted && self.state == WALFlowStateTokenLoading) {
            self.isStarted = YES;
            [self.stateHandler performWithCoordinator:self];
        }
    }
}

- (id<WALPaymentFlowContainer>)paymentContainer {
    if (!_paymentContainer) {
        _paymentContainer = [self.configuration.paymentFlowContainerFactory build]; // TODO: check rootview
    }
    return _paymentContainer;
}

@end
