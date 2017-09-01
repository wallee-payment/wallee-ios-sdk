//
//  WALTokenSelectionStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenSelectionStateHandler.h"
#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentErrorHelper.h"
#import "WALApiClient.h"

@interface WALTokenSelectionStateHandler ()
@property (nonatomic, copy) NSArray<WALTokenVersion *> *tokens;
@end

@implementation WALTokenSelectionStateHandler

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return flowAction == WALFlowActionSwitchToPaymentMethodSelection;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    if(flowAction == WALFlowActionSwitchToPaymentMethodSelection) {
        [coordinator changeStateTo:WALFlowStatePaymentMethodLoading];
        return YES;
    }
    return NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorDidDisplayTokenSelection:)]) {
        [coordinator.configuration.delegate flowCoordinatorDidDisplayTokenSelection:coordinator];
    }
    [coordinator ready];
}

- (instancetype)initWithTokens:(NSArray<WALTokenVersion *> *)tokens {
    if (self = [super init]) {
        _tokens = tokens;
    }
    return self;
}
@end
