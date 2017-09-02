//
//  WALFlowTypes.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 30.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @typedef WALFlowAction
 
  The @c FlowCoordinator allows the execution of certain actions on the flow. Those actions
  depends on the current state of the coordinator.
 
  This enum holds all possible actions which can be triggered from the outside. If a particular
  action can be executed depends on the inner state of the coordinator. To check if a particular
  action can be executed the FlowCoordinator#dryTriggerAction(FlowAction) can be
  invoked.
 
  To actually execute a particular action the method FlowCoordinator#triggerAction(FlowAction)
  can be used. See also the documentation of the actions to see when an execution is generally
  possible.

 - WALFLowActionValidatePaymentForm:  b
 - WALFlowActionSubmitPaymentForm: b
 - WALFlowActionSwitchToPaymentMethodSelection: b
 - WALFlowActionGoBack: b
 */
typedef NS_ENUM(NSInteger, WALFlowAction) {
    /**
     <p>This action triggers the validation of the payment information entered in the
     WALPaymentFormView. The validation does not send the data
     however it checks if everything entered is in the correct format and if the required input
     has been provided.</p>
     
     As a result the OnPaymentFormValidationListener
      is triggered. To listen to the result the mentioned listener may be implemented.
     */
    WALFLowActionValidatePaymentForm,
    WALFlowActionSubmitPaymentForm,
    WALFlowActionSwitchToPaymentMethodSelection,
    WALFlowActionGoBack,
};

/**
 

 - WALFlowStateTokenLoading: desc
 - WALFlowStateTokenSelection: desc
 - WALFlowStatePaymentMethodLoading: desc
 - WALFlowStatePaymentMethodSelection: desc
 - WALFlowStatePaymentForm: desc
 - WALFlowStateSuccess: desc
 - WALFlowStateFailure: desc
 - WALFlowStateAwaitingFinalState: desc
 */
typedef NS_ENUM(NSUInteger, WALFlowState){
    WALFlowStateTokenLoading,
    WALFlowStateTokenSelection,
    WALFlowStatePaymentMethodLoading,
    WALFlowStatePaymentMethodSelection,
    WALFlowStatePaymentForm,
    WALFlowStateSuccess,
    WALFlowStateFailure,
    WALFlowStateAwaitingFinalState
};

FOUNDATION_EXPORT NSString * const WALFlowTokensParameter;
FOUNDATION_EXPORT NSString * const WALFlowTransactionParameter;

@interface WALFlowTypes : NSObject

@end


