//
//  WALFlowCoordinator.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowTypes.h"

#import "WALFlowCoordinator.h"
#import "WALFlowConfiguration.h"

#import "WALPaymentFlowContainerFactory.h"
#import "WALFlowStateHandlerFactory.h"
#import "WALFlowStateHandler.h"


@interface WALFlowCoordinator ()
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic) int isStarted;

@property (nonatomic, copy) WALFlowConfiguration *configuration;
@property (nonatomic, assign) WALFlowState state;
@property (nonatomic, strong) id<WALFlowStateHandler> stateHandler;

@property (nonatomic, strong, readwrite) id<WALPaymentFlowContainer> paymentContainer;
//
//- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration;
NS_ASSUME_NONNULL_END
@end

@implementation WALFlowCoordinator
//@synthesize state;
//@synthesize stateHandler;
- (instancetype)initWithConfiguration:(WALFlowConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
        _state = WALFlowStateTokenLoading;
        _stateHandler = [WALFlowStateHandlerFactory handlerFromState:self.state stateParameters:nil];
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

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    @synchronized (self) {
        return [self.stateHandler dryTriggerAction:flowAction];
    }
}

- (BOOL)triggerAction:(WALFlowAction)flowAction {
    @synchronized (self) {
        return [self.stateHandler triggerAction:flowAction WithCoordinator:self];
    }
}

- (id<WALPaymentFlowContainer>)paymentContainer {
    if (!_paymentContainer) {
        __weak WALFlowCoordinator *weakSelf = self;
        WALContainerBackAction backAction = ^BOOL(void){
            WALFlowCoordinator *strongSelf = weakSelf;
            if (!strongSelf) {
                return NO;
            }
            if ([strongSelf dryTriggerAction:WALFlowActionGoBack]) {
                return [strongSelf triggerAction:WALFlowActionGoBack];
            } else {
                return NO;
            }
        };
        _paymentContainer = [self.configuration.paymentFlowContainerFactory buildWithBackAction:backAction]; // TODO: check rootview
    }
    return _paymentContainer;
}

@end
