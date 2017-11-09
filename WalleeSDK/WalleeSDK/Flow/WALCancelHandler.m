//
//  WALCancelHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALCancelHandler.h"
#import "WALSimpleFlowStateHandler+Private.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALViewControllerFactory.h"

@interface WALCancelHandler ()
@property (nonatomic, copy) WALTransaction *transaction;
@end

@implementation WALCancelHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithTransaction:parameters[WALFlowTransactionParameter]];
}

+ (instancetype)stateWithTransaction:(WALTransaction *)transaction {
    return [[self alloc]initWithTransaction:transaction];
}

- (instancetype)initWithTransaction:(WALTransaction *)transaction {
    if (self = [super initInternal]) {
        _transaction = transaction;
    }
    return self;
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return NO;
}

-(BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinator:transactionDidCancel:)]) {
        [coordinator.configuration.delegate flowCoordinator:coordinator
                                      transactionDidCancel:self.transaction];
    }
    
    [coordinator ready];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    UIViewController *controller = [coordinator.configuration.viewControllerFactory buildCancelViewWith:self.transaction];
    return controller;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"Cancel", @"Transaction": self.transaction}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
