//
//  WALPaymentMethodFormHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodFormStateHandler.h"
#import "WALPaymentFormView.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALViewControllerFactory.h"

#import "WALApiClient.h"
#import "WALPaymentErrorHelper.h"
#import "WALErrorDomain.h"

#import "WALPaymentMethodConfiguration.h"
#import "WALMobileSdkUrl.h"

@interface WALPaymentMethodFormStateHandler ()
@property (nonatomic) NSUInteger paymentMethodId;
@property (nonatomic, copy) NSURL *sdkUrl;
@property (nonatomic, strong) UIViewController<WALPaymentFormView> *paymentForm;
@end

@implementation WALPaymentMethodFormStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    NSNumber *paymentMethodId = parameters[WALFlowPaymentMethodsParameter];
    return [self.class stateWithPaymentMethodId:paymentMethodId.unsignedIntegerValue];
}

+ (instancetype)stateWithPaymentMethodId:(NSUInteger)paymentMethodId {
    if (paymentMethodId == 0) {
        return nil;
    }
    return [[self alloc] initWithPaymentMethodId:paymentMethodId];
}

- (instancetype)initWithPaymentMethodId:(NSUInteger)paymentMethodId {
    if (self = [super init]) {
        self.paymentMethodId = paymentMethodId;
    }
    return self;
}

// MARK: - State Handler

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    // currentView instanceof PaymentFormView && <- hmmm...
    BOOL currentViewIsSubmited = NO;
    return flowAction == WALFlowActionSubmitPaymentForm || flowAction == WALFLowActionValidatePaymentForm || (flowAction == WALFlowActionGoBack && !currentViewIsSubmited);
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    if (![self dryTriggerAction:flowAction]) {
        return NO;
    }
    
    if (flowAction == WALFlowActionSubmitPaymentForm) {
        [self.paymentForm submit];
    } else if (flowAction == WALFLowActionValidatePaymentForm) {
        [self.paymentForm validate];
    } else if (flowAction == WALFlowActionGoBack) {
        if (self.paymentForm.isSubmitted) {
            NSError *error;
            [WALErrorHelper populate:&error withIllegalStateWithMessage:@"GoBack action received while the PaymentForm was already submitted. Should never occure since it is checked in dryAction before"];
            [WALPaymentErrorHelper distribute:error forCoordinator:coordinator];
        } else {
            [coordinator changeStateTo:WALFlowStatePaymentMethodLoading parameters:nil];
        }
    } else {
        NSAssert(true, @"When dryAction is correctly implemented we will never get here...");
    }
    
    return YES;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [coordinator waiting];
    // delegate
    
    //load payment url
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    __weak WALPaymentMethodFormStateHandler *weakSelf = self;
    [coordinator.configuration.webServiceApiClient buildMobileSdkUrl:^(WALMobileSdkUrl * _Nullable mobileSdkUrl, NSError * _Nullable error) {
        if (!mobileSdkUrl) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        WALPaymentMethodFormStateHandler *strongSelf = weakSelf;
        strongSelf.sdkUrl = [mobileSdkUrl buildPaymentMethodUrl:strongSelf.paymentMethodId error:&error];
        if (!strongSelf.sdkUrl) {
            [WALPaymentErrorHelper distribute:error forCoordinator:weakCoordinator];
            return;
        }
        
        // send on weak. noop if already deallocated
        [weakCoordinator ready];
    }];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    if (!self.sdkUrl) {
        return nil;
    }
    if (!self.paymentForm) {
        self.paymentForm = [coordinator.configuration.viewControllerFactory buildPaymentMethodFormViewWithURL:self.sdkUrl];
    }
        // TODO: Callback for submit?
    return self.paymentForm;
}

// MARK: - PaymentFormDelegation
- (void)paymentViewDidValidateSuccessful:(UIViewController *)viewController {
    
}
@end
