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

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [[self alloc] init];
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return NO;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    [coordinator waiting];
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorWillLoadToken:)]) {
        [coordinator.configuration.delegate flowCoordinatorWillLoadToken:coordinator];
    }
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    [coordinator.configuration.webServiceApiClient fetchTokenVersions:^(NSArray<WALTokenVersion *> * _Nullable tokenVersions, NSError * _Nullable error) {
        if (!tokenVersions) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        
        // !!!: testing
        if (tokenVersions.count <= 0) {
//        if (tokenVersions.count > 0) {
            [weakCoordinator changeStateTo:WALFlowStatePaymentMethodLoading parameters:nil];
        } else {
            // TODO: Load icons for payment configurations
            [weakCoordinator changeStateTo:WALFlowStateTokenSelection parameters:@{WALFlowTokensParameter: tokenVersions}];
        }
        
    }];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    return nil;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"TokenLoading"}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
