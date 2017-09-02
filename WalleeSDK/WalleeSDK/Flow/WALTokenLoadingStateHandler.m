//
//  WALTokenLoadingStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenLoadingStateHandler.h"
#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentErrorHelper.h"
#import "WALApiClient.h"

@interface WALTokenLoadingStateHandler ()

@end

@implementation WALTokenLoadingStateHandler

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return NO;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorWillLoadToken:)]) {
        [coordinator.configuration.delegate flowCoordinatorWillLoadToken:coordinator];
    }
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    [coordinator.configuration.webServiceApiClient fetchTokenVersions:^(NSArray<WALTokenVersion *> * _Nullable tokenVersions, NSError * _Nullable error) {
        if (!tokenVersions && error) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        
        if (tokenVersions.count <= 0) {
            [weakCoordinator changeStateTo:WALFlowStatePaymentMethodLoading];
        } else {
            // Load icons for payment configurations
            [weakCoordinator changeStateTo:WALFlowStateTokenSelection];
        }
        
    }];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    return nil;
}
@end
