//
//  WALSimpleFlowStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSimpleFlowStateHandler.h"
#import "WALFlowCoordinator.h"
#import "WALErrorDomain.h"
#import "WALPaymentErrorHelper.h"

@interface WALSimpleFlowStateHandler ()
@property (nonatomic) BOOL alive;
@end

@implementation WALSimpleFlowStateHandler

- (instancetype)init {
    if (self = [super init]) {
        _alive = YES;
    }
    return self;
}

- (BOOL)isValid {
    return self.alive;
}

- (void)invalidate {
    self.alive = NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    NSAssert(coordinator != nil, @"WALFlowCoordinator cannot be nil");
    NSAssert(coordinator.configuration != nil, @"WALFlowCoordinator.configuration cannot be nil");
    NSAssert([self isValid], @"Trying to run Action on invalidated StateHandler");
    [self.class isStateValid:self WithCoordinator:coordinator];
    
}


+ (BOOL)isStateValid:(id<WALLifeCycleObject>)state WithCoordinator:(WALFlowCoordinator *)coordinator {
    NSError *error;
    if (![WALErrorHelper checkState:state error:&error]) {
        [WALPaymentErrorHelper distribute:error forCoordinator:coordinator];
        return NO;
    }
    return YES;
}

@end
