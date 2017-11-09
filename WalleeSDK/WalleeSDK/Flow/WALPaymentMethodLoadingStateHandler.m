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

@interface WALPaymentMethodLoadingStateHandler ()
@property (nonatomic, copy) WALLoadedTokens *loadedTokens;
@end

@implementation WALPaymentMethodLoadingStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithTokens:parameters[WALFlowTokensParameter]];
}

+ (instancetype)stateWithTokens:(WALLoadedTokens *)loadedTokens {
    if (!loadedTokens.tokenVersions) {
        return nil;
    }
    return [[self alloc] initWithTokens:loadedTokens];
}

- (instancetype)initWithTokens:(WALLoadedTokens *)loadedTokens {
    if (self = [self initInternal]) {
        _loadedTokens = loadedTokens;
    }
    return self;
}

// MARK: -
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
    
    __weak WALPaymentMethodLoadingStateHandler *weakSelf = self;
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    [coordinator.configuration.webServiceApiClient fetchPaymentMethodConfigurations:^(NSArray<WALPaymentMethodConfiguration *> * _Nullable paymentMethodConfigurations, NSError * _Nullable error) {
        if (!paymentMethodConfigurations) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        
        if (paymentMethodConfigurations.count <= 0) {
            
            [weakCoordinator changeStateTo:WALFlowStateCancel parameters:nil];
            
        } else if (paymentMethodConfigurations.count == 1) {
            NSUInteger paymentId = paymentMethodConfigurations[0].objectId;
            [weakCoordinator changeStateTo:WALFlowStatePaymentForm
                                parameters:@{WALFlowTokensParameter: weakSelf.loadedTokens,
                                             WALFlowPaymentMethodsParameter: paymentMethodConfigurations,
                                             WALFlowPaymentMethodIdParameter: @(paymentId)}];
            
        } else {
            [weakCoordinator.configuration.iconCache fetchIcons:paymentMethodConfigurations completion:^(NSDictionary<WALPaymentMethodConfiguration *,WALPaymentMethodIcon *> * _Nullable paymentMethodIcons, NSError * _Nullable error) {
                
                WALLoadedPaymentMethods *loaded = [[WALLoadedPaymentMethods alloc] initWithPaymentMethodConfigurations:paymentMethodConfigurations
                                                                                                    paymentMethodIcons:paymentMethodIcons];
                
            [weakCoordinator changeStateTo:WALFlowStatePaymentMethodSelection
                                parameters:@{WALFlowTokensParameter: weakSelf.loadedTokens,
                                             WALFlowPaymentMethodsParameter: loaded}];
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
