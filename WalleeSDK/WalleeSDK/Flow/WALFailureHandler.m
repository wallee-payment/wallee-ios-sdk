//
//  WALFailureHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFailureHandler.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALViewControllerFactory.h"

@interface WALFailureHandler ()
@property (nonatomic, copy) WALTransaction *transaction;
@end

@implementation WALFailureHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithTransaction:parameters[WALFlowTransactionParameter]];
}

+ (instancetype)stateWithTransaction:(WALTransaction *)transaction {
    if (!transaction) {
        return nil;
    }
    return [[self alloc]initWithTransaction:transaction];
}

- (instancetype)initWithTransaction:(WALTransaction *)transaction {
    if (self = [super init]) {
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
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinator:transactionDidFail:)]) {
        [coordinator.configuration.delegate flowCoordinator:coordinator transactionDidFail:self.transaction];
    }
    
    [coordinator ready];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    
    UIViewController *controller = [coordinator.configuration.viewControllerFactory buildFailureViewWith:self.transaction];
    return controller;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"Failure", @"Transaction": self.transaction}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
