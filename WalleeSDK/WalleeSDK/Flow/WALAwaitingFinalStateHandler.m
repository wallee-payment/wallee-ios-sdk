//
//  WALAwaitingFinalStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALAwaitingFinalStateHandler.h"
#import "WALSimpleFlowStateHandler+Private.h"

#import "WALViewControllerFactory.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowConfiguration.h"
#import "WALApiClient.h"

#import "WALPaymentErrorHelper.h"

#import "WALTransaction.h"

@interface WALAwaitingFinalStateHandler ()
@property (nonatomic, copy) WALTransaction *transaction;
@end

@implementation WALAwaitingFinalStateHandler

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return NO;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return NO;
}


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
    if (self = [super initInternal]) {
        _transaction = transaction;
    }
    return self;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [coordinator ready];
    [self reschedule];
}

- (void)reschedule {
    __weak WALFlowCoordinator *weakCoordinator;
    __weak WALAwaitingFinalStateHandler *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakCoordinator.configuration.webServiceApiClient readTransaction:^(WALTransaction * _Nullable transaction, NSError * _Nullable error) {
            
            if (!transaction) {
                [WALPaymentErrorHelper distribute:error forCoordinator:weakCoordinator];
                return;
            }
            
            if (transaction.isSuccessful) {
                [weakCoordinator changeStateTo:WALFlowStateSuccess parameters:nil];
            } else if (transaction.isFailed) {
                [weakCoordinator changeStateTo:WALFlowStateFailure parameters:nil];
            } else if(transaction.isWaitingFinalState) {
                [weakSelf reschedule];
            }
        }];

    });
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    return [coordinator.configuration.viewControllerFactory buildAwaitingFinalStateViewWith:self.transaction];
}

@end
