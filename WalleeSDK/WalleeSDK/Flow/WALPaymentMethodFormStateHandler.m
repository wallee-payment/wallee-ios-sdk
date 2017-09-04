//
//  WALPaymentMethodFormHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodFormStateHandler.h"

#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALViewControllerFactory.h"

#import "WALApiClient.h"
#import "WALPaymentErrorHelper.h"

#import "WALPaymentMethodConfiguration.h"
#import "WALMobileSdkUrl.h"

@interface WALPaymentMethodFormStateHandler ()
@property (nonatomic) NSUInteger paymentMethodId;
@property (nonatomic, copy) NSURL *sdkUrl;
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


//public boolean triggerAction(FlowAction action, View currentView) {
//    if (dryTriggerAction(action, currentView)) {
//        if (action == FlowAction.SUBMIT_PAYMENT_FORM) {
//            ((PaymentFormView) currentView).submit();
//        } else if (action == FlowAction.VALIDATE_PAYMENT_FORM) {
//            ((PaymentFormView) currentView).validate();
//        } else if (action == FlowAction.GO_BACK) {
//            if (((PaymentFormView) currentView).isSubmitted()) {
//                throw new IllegalStateException("This should not happen. We check that before in the dry method.");
//            }
//            this.stateChanger.changeStateTo(FlowState.PAYMENT_METHOD_LOADING, null);
//        } else {
//            throw new IllegalStateException("When the dry is correctly implemented we should never reach this code.");
//        }
//        return true;
//    } else {
//        return false;

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    return false;
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
    if (self.sdkUrl) {
        return [coordinator.configuration.viewControllerFactory buildPaymentMethodFormViewWithURL:self.sdkUrl];
    }
    return nil;
    
}

@end
