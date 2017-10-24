//
//  WALPaymentMethodFormHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodFormStateHandler.h"
#import "WALPaymentFormView.h"

#import "WALSimpleFlowStateHandler+Private.h"

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
@property (nonatomic, copy) WALMobileSdkUrl *sdkUrl;
@property (nonatomic, strong) UIViewController<WALPaymentFormView> *paymentForm;

/// this is the only state that has to hold a reference to the @c WALCoordinator
/// because of its asynchronous delegate methods
@property (nonatomic, weak) WALFlowCoordinator *coordinatorDelegate;
@end

@implementation WALPaymentMethodFormStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    WALPaymentMethodConfiguration *paymentMethod = parameters[WALFlowPaymentMethodsParameter];
    return [self.class stateWithPaymentMethodId:paymentMethod.objectId];
}

+ (instancetype)stateWithPaymentMethodId:(NSUInteger)paymentMethodId {
    if (paymentMethodId == 0) {
        return nil;
    }
    return [[self alloc] initWithPaymentMethodId:paymentMethodId];
}

- (instancetype)initWithPaymentMethodId:(NSUInteger)paymentMethodId {
    if (self = [super initInternal]) {
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

    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    __weak WALPaymentMethodFormStateHandler *weakSelf = self;
    [coordinator.configuration.webServiceApiClient buildMobileSdkUrl:^(WALMobileSdkUrl * _Nullable mobileSdkUrl, NSError * _Nullable error) {
        if (!mobileSdkUrl) {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
            return;
        }
        
        weakSelf.sdkUrl = mobileSdkUrl;
        
        // send on weak. noop if already deallocated
        [weakCoordinator ready];
    }];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    if (!self.sdkUrl) {
        return nil;
    }
    if (!self.paymentForm) {
        __weak WALPaymentMethodFormStateHandler *weakSelf = self;
        self.paymentForm = [coordinator.configuration.viewControllerFactory
                            buildPaymentMethodFormViewWithURL:self.sdkUrl
                            paymentMethod:self.paymentMethodId
                            onBack:^{
                                
                                [weakSelf triggerAction:WALFlowActionGoBack WithCoordinator:weakSelf.coordinatorDelegate];
                                
                            }];
        self.paymentForm.delegate = self;
    }
    return self.paymentForm;
}

// MARK: - PaymentFormDelegation
- (void)viewDidStartLoading:(UIView *)viewController {
    [self.coordinatorDelegate waiting];
}

- (void)viewDidFinishLoading:(UIView *)viewController {
    [self.coordinatorDelegate ready];
}

- (void)paymentViewDidValidateSuccessful {
    if (!self.paymentForm.isSubmitted) {
        [self.paymentForm submit];
    }
}

- (void)paymentViewDidFailValidationWithErrors:(NSArray<NSError *> *)errors {
    // no action needed
}

-(void)viewControllerDidExpire:(UIViewController *)viewController {

    [self.coordinatorDelegate changeStateTo:WALFlowStatePaymentForm parameters:@{WALFlowPaymentMethodsParameter: @(self.paymentMethodId)}];
}

- (void)paymentViewDidEncounterError:(NSError *)error {
    [WALPaymentErrorHelper distribute:error forCoordinator:self.coordinatorDelegate];
}

- (void)paymentViewDidSucceed {
    [self readAndEvaluateTransactionForState:WALFlowStateSuccess];
}

- (void)paymentViewDidFail {
    [self readAndEvaluateTransactionForState:WALFlowStateFailure];
}

- (void)paymentViewAwaitsFinalState {
    [self readAndEvaluateTransactionForState:WALFlowStateAwaitingFinalState];
}

- (void)paymentViewDidRequestChangePaymentMethod {
    [self triggerAction:WALFlowActionGoBack WithCoordinator:self.coordinatorDelegate];
}

- (void)paymentViewDidChangeContentSize:(CGSize)size {
    // the handler does not care about this message
}

- (void)paymentViewRequestsExpand {
    // the handler does not care about this message
}

- (void)paymentViewRequestsReset {
    // the handler does not care about this message
}

// MARK: - Internal
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
