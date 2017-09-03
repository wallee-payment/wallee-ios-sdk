//
//  WALFlowCoordinator+StateDelegate.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowCoordinator+Private.h"
#import "WALFlowCoordinator.h"
#import "WALFlowStateHandler.h"
#import "WALPaymentFlowContainer.h"
#import "WALFlowStateHandlerFactory.h"

#import "WALPaymentErrorHelper.h"


@implementation WALFlowCoordinator (StateDelegate)

- (void)changeStateTo:(WALFlowState)targetState parameters:(NSDictionary *)parameters {
    id<WALFlowStateHandler> nextStateHandler = [WALFlowStateHandlerFactory handlerFromState:targetState stateParameters:parameters];
    //TODO: currentState invalidate?
    self.state = targetState;
    self.stateHandler = nextStateHandler;
    [self.stateHandler performWithCoordinator:self];
}

- (void)waiting {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.paymentContainer displayLoading];
    });
}

- (void)ready {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Dispatched Ready on MAin");
        UIViewController * controller = [self.stateHandler viewControllerForCoordinator:self];
        NSAssert(controller != nil, @"Implementation Error: State does not return a ViewController: %@", self.stateHandler.debugDescription);
        
        [self.paymentContainer displayViewController:controller];
    });
}

@end
