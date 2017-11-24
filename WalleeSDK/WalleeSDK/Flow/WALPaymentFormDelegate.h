//
//  WALPaymentFormDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALLoadingViewDelegate.h"
#import "WALExpiringViewDelegate.h"

/**
 The delegate of a WALPaymentFormView must adopt the @c WALPaymentFormDelegate protocol
 
 the WALPaymentFormView use these methods to communicate back internal  state changes, requests and errors
 */
@protocol WALPaymentFormDelegate <NSObject, WALLoadingViewDelegate, WALExpiringViewDelegate>

/**
 * Called when the payment form is ready.
 * The user may enter some data.
 */
- (void)paymentViewReady:(BOOL)userInteractionNeeded;

/**
 called whenever the WALPaymentFormView changed its content size

 @param size the new size of the WALPaymentFormView
 */
- (void)paymentViewDidChangeContentSize:(CGSize)size;

/**
 the WALPaymentFormView has been forwarded to an external site and as such it should be displayed in fullscreen mode
 */
- (void)paymentViewRequestsExpand;

/**
 the WALPaymentFormView wants to be restored to its former size. usually tha last reported @paymentViewDidChangeContentSize
 */
- (void)paymentViewRequestsReset;

/**
 reports that the user wants to change the payment method, as such the WALPaymentFormView can be discarded
 */
- (void)paymentViewDidRequestChangePaymentMethod;

/**
 indicates that the WALPaymentFormView has validated the form content and as such we can process this transaction

 */
- (void)paymentViewDidValidateSuccessful;

/**
 indicates that the WALPaymentFormView has failed validating the form content and as such
 we should give the user the possibility to change the content and resubmit it

 @param errors the errors as reported by WALPaymentFormView
 */
- (void)paymentViewDidFailValidationWithErrors:(NSArray<NSError *> *)errors;

/**
 the WALPaymentFormView did succeed in transmitting the transaction. as such the transaction is valid and 
 the payment is recorded.
 
 the implementor can as such either cancel the flow and display the success to the user or let the WALFlowCoordinator do this job.

 */
- (void)paymentViewDidSucceed;

/**
 the WALPaymentFormView reports that the transaction failed and as such we should end the flow and display
 the error to the user.
 
 either by letting the WALFlowCoordinator flow handler do it or by cancelling the flow directly.

 */
- (void)paymentViewDidFail;

/**
 the WALPaymentFormView reports that the transaction is awaiting its final state. this can take up to several minutes

 */
- (void)paymentViewAwaitsFinalState;

/**
 th WALPaymentFormView reports an error and as such the payment flow should propably be canceled

 @param error the errors reportet by the WALPaymentFormView
 */
- (void)paymentViewDidEncounterError:(NSError *)error;
@end
