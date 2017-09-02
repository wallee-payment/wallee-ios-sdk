//
//  WALSuccessHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSuccessHandler.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentFlowDelegate.h"

@interface WALSuccessHandler ()
@property (nonatomic, copy) WALTransaction *transaction;
@end

@implementation WALSuccessHandler

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
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinator:transactionDidSucceed:)]) {
        [coordinator.configuration.delegate flowCoordinator:coordinator transactionDidSucceed:self.transaction];
    }
    
    [coordinator ready];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    
    return nil;
}
@end
