//
//  WALPaymentMethodLoadingStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodLoadingStateHandler.h"
#import "WALSimpleFlowStateHandler+Private.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALFlowStateDelegate.h"

#import "WALPaymentErrorHelper.h"
#import "WALApiClient.h"
#import "WALIconCache.h"

#import "WALLoadedPaymentMethods.h"
#import "WALPaymentMethodConfiguration.h"

@implementation WALPaymentMethodLoadingStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [[self alloc] initInternal];
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return NO;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return NO;
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    return nil;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    [coordinator waiting];
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorWillLoadPaymentMethod:)]) {
        [coordinator.configuration.delegate flowCoordinatorWillLoadPaymentMethod:coordinator];
    }
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    [coordinator.configuration.webServiceApiClient fetchPaymentMethodConfigurations:^(NSArray<WALPaymentMethodConfiguration *> * _Nullable paymentMethodConfigurations, NSError * _Nullable error) {
        if (!paymentMethodConfigurations) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        
        if (paymentMethodConfigurations.count == 1) {
            NSUInteger paymentId = paymentMethodConfigurations[0].objectId;
            [weakCoordinator changeStateTo:WALFlowStatePaymentForm
                                parameters:@{WALFlowPaymentMethodsParameter: @(paymentId)}];
            
        } else {
            [weakCoordinator.configuration.iconCache fetchIcons:paymentMethodConfigurations completion:^(NSDictionary<WALPaymentMethodConfiguration *,WALPaymentMethodIcon *> * _Nullable paymentMethodIcons, NSError * _Nullable error) {
                
                WALLoadedPaymentMethods *loaded = [[WALLoadedPaymentMethods alloc] initWithPaymentMethodConfigurations:paymentMethodConfigurations paymentMethodIcons:paymentMethodIcons];
                
            [weakCoordinator changeStateTo:WALFlowStatePaymentMethodSelection parameters:@{WALFlowPaymentMethodsParameter: loaded}];
            }];
        }
    }];
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"PaymentMethodLoading"}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}


@end
