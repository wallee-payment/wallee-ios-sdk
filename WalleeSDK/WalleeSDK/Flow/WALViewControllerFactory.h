//
//  WALViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTransaction, WALTokenVersion, WALLoadedTokens, WALLoadedPaymentMethods, WALPaymentMethodConfiguration, WALMobileSdkUrl;
@protocol WALPaymentFormView;

/**
 This block is called when a token has been selected by the user.

 @param tokenVersion the selected Token
 */
typedef void(^WALTokenVersionSelected)(WALTokenVersion *_Nonnull tokenVersion);
/**
 This this block is called when the user wants to navigat back.
 */
typedef void(^WALOnBackBlock)(void);
/**
 This block is called when the user has selected a payment method

 @param paymentMethod the selected method
 */
typedef void(^WALPaymentMethodSelected)(WALPaymentMethodConfiguration *_Nonnull paymentMethod);
/**
 This block is called when the user has submited the payment method via the payment form

 @param paymentMethod the method being submitted
 */
typedef void(^WALPaymentMethodSubmited)(WALPaymentMethodConfiguration *_Nonnull paymentMethod);



/**
 Implementing and supplying a dedicated @c WALViewControllerFactory allows to override the viewcontrollers
 to be shown to the user in the given situations.
 */
@protocol WALViewControllerFactory <NSObject>

/**
 A transaction may not switch into a final state immediately. This may take some time. This
 method is responsible to create a view which indicates to the user that a final result will
 arrive within serveral minutes.

 @param transaction the transaction awaiting a final state
 @return the view to display
 */
- (UIViewController *_Nonnull)buildAwaitingFinalStateViewWith:(WALTransaction * _Nonnull)transaction;


/**
 This method is responsible to create a view which is shown when the transaction is succeeding.
 
 A transaction succeeds when at least the authorization of the transaction is successful. This
 factory creates a view which is shown in this situation.

 @param transaction the succeded transaction
 @return the view controller to display
 */
- (UIViewController *_Nonnull)buildSuccessViewWith:(WALTransaction * _Nonnull)transaction;


/**
 This method is responsible to create the view which is shown to the customer when the
 transaction is failing.

 @note The @c WALTransaction.userFailureMessage describes in the user language what went wrong.
 
 @param transaction the failing transaction
 @return a view controller to display
 */
- (UIViewController *_Nonnull)buildFailureViewWith:(WALTransaction * _Nonnull)transaction;


/**
 This method is responsible to create the view which is shown to the customer when the trancation is
 canceled by the customer.

 @param transaction can be nil
 @return a view controller to display
 */
- (UIViewController *_Nonnull)buildCancelViewWith:(WALTransaction * _Nullable)transaction;

/**
 
  The token list allows the user to select from a list of stored payment details (like card or a
  PayPal account). The list is generated based up on the transaction and as such on the customer ID
  set on the transaction.

 @param loadedTokens the list of tokens to display
 @param callback the block to run if the user selects a TokenVersion
 @param changePaymentMethod the block to run if the user wants to swicht payment methods
 @return the view controller to use
 */
- (UIViewController *_Nonnull)buildTokenListViewWith:(WALLoadedTokens *_Nonnull)loadedTokens
                                         onSelection:(WALTokenVersionSelected _Nullable )callback
                               onChangePaymentMethod:(WALOnBackBlock _Nullable)changePaymentMethod
                                              onBack:(WALOnBackBlock _Nullable)onBack;

/**
 The payment method selection view allows the user to select from a list of payment methods
 the one which should be used to process the transaction with.

 @param loadedPaymentMethods the payment methods from which the user can choose
 @param callback the callback block to invoke when the user selects a payment method
 @param onBack the block to invoke if the user wants to perform a back action (eg. to get to the TokenList)
 @return the viewcontroller to display the payment methods
 */
- (UIViewController *_Nonnull)buildPaymentMethodListViewWith:(WALLoadedPaymentMethods *_Nonnull)loadedPaymentMethods
                                                 onSelection:(WALPaymentMethodSelected _Nullable)callback
                                                      onBack:(WALOnBackBlock _Nonnull)onBack;


/**
 The payment form view controller is responsible to create a view which holds the payment form.
 
  <p>The payment form contains the input fields for collecting the payment details. Typically this
  is a {@link android.webkit.WebView} with a form loaded from the remote server.</p>

 @param mobileSdkUrl the mobileSdkUrl to use to create the final url
 @param paymentMethodId the methodId for which the payment form should be created for
 @param onBack the block to invoke when the user wants to navigate back
 @return the view controller to display
 */
- (UIViewController<WALPaymentFormView> *_Nonnull)buildPaymentMethodFormViewWithURL:(WALMobileSdkUrl * _Nonnull)mobileSdkUrl
                                                                      paymentMethod:(NSUInteger)paymentMethodId
                                                                             onBack:(WALOnBackBlock _Nonnull )onBack;

@end
