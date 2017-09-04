//
//  WALPaymentMethodSelectionHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodSelectionStateHandler.h"
#import "WALPaymentMethodConfiguration.h"

#import "WALFlowCoordinator+StateDelegate.h"

#import "WALFlowConfiguration.h"
#import "WALPaymentFlowDelegate.h"
#import "WALViewControllerFactory.h"

#import "WALPaymentErrorHelper.h"
#import "WALErrorDomain.h"

#import "WALApiClient.h"

@interface WALPaymentMethodSelectionStateHandler ()
@property (nonatomic, copy) NSArray<WALPaymentMethodConfiguration *> *paymentMethods;
@end

@implementation WALPaymentMethodSelectionStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithPaymentMethods:parameters[WALFlowPaymentMethodsParameter]];
}

+ (instancetype)stateWithPaymentMethods:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethods {
    if (!paymentMethods || paymentMethods.count <= 0) {
        return nil;
    }
    return [[self alloc] initWithPaymentMethods:paymentMethods];
}

- (instancetype)initWithPaymentMethods:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethods {
    if (self = [super init]) {
        _paymentMethods = paymentMethods;
    }
    return self;
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return flowAction == WALFlowActionGoBack;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    if ([self dryTriggerAction:flowAction]) {
        [coordinator changeStateTo:WALFlowStatePaymentMethodLoading parameters:nil];
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
    __weak WALFlowCoordinator *weakCoordinator = coordinator;

    UIViewController *controller = [coordinator.configuration.viewControllerFactory
                                    buildPaymentMethodListViewWith:self.paymentMethods
                                    onSelection:^(WALPaymentMethodConfiguration * _Nonnull paymentMethod) {
                                        NSDictionary *parameter = @{WALFlowPaymentMethodsParameter: @(paymentMethod.objectId)};
                                        [weakCoordinator changeStateTo:WALFlowStatePaymentForm parameters:parameter];
    }];
    return controller;
}

@end
