//
//  WALPaymentMethodSelectionHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodSelectionStateHandler.h"
#import "WALPaymentMethodConfiguration.h"
#import "WALLoadedPaymentMethods.h"

#import "WALSimpleFlowStateHandler+Private.h"
#import "WALFlowCoordinator+StateDelegate.h"

#import "WALFlowConfiguration.h"
#import "WALPaymentFlowDelegate.h"
#import "WALViewControllerFactory.h"

#import "WALPaymentErrorHelper.h"
#import "WALErrorDomain.h"

#import "WALApiClient.h"

@interface WALPaymentMethodSelectionStateHandler ()
@property (nonatomic, copy) WALLoadedPaymentMethods *loadedPaymentMethods;
@property (nonatomic, copy) WALLoadedTokens *loadedTokens;
@end

@implementation WALPaymentMethodSelectionStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithPaymentMethods:parameters[WALFlowPaymentMethodsParameter]
                               andTokens:parameters[WALFlowTokensParameter]];
}

+ (instancetype)stateWithPaymentMethods:(WALLoadedPaymentMethods *)loadedPaymentMethods
                                    andTokens:(WALLoadedTokens *)loadedTokens {
    if (loadedPaymentMethods.paymentMethodConfigurations.count <= 0 || !loadedTokens) {
        return nil;
    }
    return [[self alloc] initWithPaymentMethods:loadedPaymentMethods andTokens:loadedTokens];
}

- (instancetype)initWithPaymentMethods:(WALLoadedPaymentMethods *)loadedPaymentMethods
                             andTokens:(WALLoadedTokens *) loadedTokens {
    if (self = [super initInternal]) {
        _loadedPaymentMethods = loadedPaymentMethods;
        _loadedTokens = loadedTokens;
    }
    return self;
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return flowAction == WALFlowActionGoBack;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    if (![WALSimpleFlowStateHandler isStateValid:self WithCoordinator:coordinator]) {
        return NO;
    }
    if ([self dryTriggerAction:flowAction]) {
        if (self.loadedTokens.tokenVersions.count <= 0) {
            [coordinator changeStateTo:WALFlowStateCancel parameters:nil];
        } else {
            [coordinator changeStateTo:WALFlowStateTokenLoading parameters:nil];
        }
        return YES;
    } else {
        return NO;
    }
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorWillDisplayPaymentMethodSelection:)]) {
        [coordinator.configuration.delegate flowCoordinatorWillDisplayPaymentMethodSelection:coordinator];
    }
    [coordinator ready];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    __weak WALPaymentMethodSelectionStateHandler *weakSelf = self;
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    WALPaymentMethodSelected onSelectionBlock = ^(WALPaymentMethodConfiguration * _Nonnull paymentMethod) {
        if (![WALSimpleFlowStateHandler isStateValid:weakSelf WithCoordinator:weakCoordinator]) {
            return;
        }
        NSDictionary *parameter = @{WALFlowPaymentMethodIdParameter: @(paymentMethod.objectId),
                                    WALFlowPaymentMethodsParameter: self.loadedPaymentMethods,
                                    WALFlowTokensParameter: self.loadedTokens};
        [weakCoordinator changeStateTo:WALFlowStatePaymentForm parameters:parameter];
    };
    
    UIViewController *controller = [coordinator.configuration.viewControllerFactory
                                    buildPaymentMethodListViewWith:self.loadedPaymentMethods
                                    onSelection:onSelectionBlock
                                    onBack:^{
                                        [weakSelf triggerAction:WALFlowActionGoBack WithCoordinator:weakCoordinator];
                                    }];
    return controller;
}

@end
