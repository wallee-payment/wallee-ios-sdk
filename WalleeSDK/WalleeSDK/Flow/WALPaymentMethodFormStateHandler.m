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
#import "WALTransaction.h"

@interface WALPaymentMethodFormStateHandler ()
@property (nonatomic) NSUInteger paymentMethodId;
@property (nonatomic, copy) NSURL *sdkUrl;
@property (nonatomic, strong) UIViewController<WALPaymentFormView> *paymentForm;
/// this is the only state that has to hold a reference to the @c WALCoordinator
/// because of its asynchronous delegate methods
@property (nonatomic, weak) WALFlowCoordinator *coordinatorDelegate;
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
    
    if (![WALSimpleFlowStateHandler isStateValid:self WithCoordinator:coordinator]) {
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
    self.coordinatorDelegate = coordinator;
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
        self.paymentForm.delegate = self;
    }
        // TODO: Callback for submit?
    return self.paymentForm;
}

// MARK: - PaymentFormDelegation
- (void)viewDidStartLoading:(UIView *)viewController {
    [self.coordinatorDelegate waiting];
}

- (void)viewDidFinishLoading:(UIView *)viewController {
    [self.coordinatorDelegate ready];
}

- (void)paymentViewDidValidateSuccessful:(UIViewController *)viewController {
    if (!self.paymentForm.isSubmitted) {
        [self.paymentForm submit];
    }
}

- (void)paymentView:(UIViewController *)viewController didFailValidationWithErrors:(NSArray<NSError *> *)errors {
    // no action needed
}

-(void)viewControllerDidExpire:(UIViewController *)viewController {
// TODO: Did Expire! --> Handle State internally?
    [self.coordinatorDelegate changeStateTo:WALFlowStatePaymentForm parameters:@{WALFlowPaymentMethodsParameter: @(self.paymentMethodId)}];
}

- (void)paymentView:(UIViewController *)viewController didEncounterError:(NSError *)error {
    [WALPaymentErrorHelper distribute:error forCoordinator:self.coordinatorDelegate];
}

- (void)paymentViewDidSucceed:(UIViewController *)viewController {
    [self readAndEvaluateTransactionForState:WALFlowStateSuccess];
}

- (void)paymentViewDidFail:(UIViewController *)viewController {
    [self readAndEvaluateTransactionForState:WALFlowStateFailure];
}

- (void)paymentViewAwaitsFinalState:(UIViewController *)viewController {
    [self readAndEvaluateTransactionForState:WALFlowStateAwaitingFinalState];
}

- (void)readAndEvaluateTransactionForState:(WALFlowState)state {
    [self.coordinatorDelegate waiting];
    __weak WALPaymentMethodFormStateHandler *weakSelf = self;
    [self.coordinatorDelegate.configuration.webServiceApiClient readTransaction:^(WALTransaction * _Nullable transaction, NSError * _Nullable error) {
        WALPaymentMethodFormStateHandler *strongSelf = weakSelf;
        [self evaluateTransactionResult:transaction error:error successorState:state forCoordinator:strongSelf.coordinatorDelegate];
    }];
}

- (void)evaluateTransactionResult:(WALTransaction * _Nullable)transaction error:(NSError * _Nullable)error successorState:(WALFlowState)state forCoordinator:(WALFlowCoordinator * _Nullable)coordinator {
    if (!coordinator) {
        return;
    }
    if (!transaction) {
        [WALPaymentErrorHelper distribute:error forCoordinator:coordinator];
        return;
    }
    if (state == WALFlowStateAwaitingFinalState) {
        if (transaction.isWaitingFinalState) {
            [coordinator changeStateTo:WALFlowStateAwaitingFinalState parameters:@{WALFlowTransactionParameter: transaction}];
        } else if (transaction.isSuccessful) {
            [coordinator changeStateTo:WALFlowStateSuccess parameters:@{WALFlowTransactionParameter: transaction}];
        } else {
            [coordinator changeStateTo:WALFlowStateFailure parameters:@{WALFlowTransactionParameter: transaction}];
        }
    } else {
        [coordinator changeStateTo:state parameters:@{WALFlowTransactionParameter: transaction}];
    }
}
@end
