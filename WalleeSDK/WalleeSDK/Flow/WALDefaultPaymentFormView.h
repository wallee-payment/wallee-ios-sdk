//
//  WALDefaultPaymentFormView.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WALPaymentFormView.h"
@class WALMobileSdkUrl;
@protocol WALPaymentFormDelegate;

@interface WALDefaultPaymentFormView : UIView<WALPaymentFormView, WKNavigationDelegate, WKScriptMessageHandler>
NS_ASSUME_NONNULL_BEGIN

/**
 The Delegate gets informed about all corresponding events
 */
@property (nonatomic, weak) id<WALPaymentFormDelegate> delegate;

/**
 the webview that displayes the paymentform
 */
@property (nonatomic, strong, readonly) WKWebView *webView;

@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL isSubmitted;
/**
 Defaults to true.
 if disabled the internal webView will disable scrolling and set its frame to its content size.
 you should then observe @c defaultPaymentFragment.contentSize and adapt your ViewController Layout accordingly.
 */
@property (nonatomic) BOOL scrollingEnabled;

/**
 Defaults to false.
 indicates it this form can be submited via AJAX
 */
@property (nonatomic) BOOL canSubmitForm;
/**
 Defaults to false.
 indicates it this form can be validated via AJAX
 */
@property (nonatomic) BOOL canValidateForm;

/**
 the contens size of the loaded @c NSURL
 */
@property (nonatomic, readonly) CGSize contentSize;

/**
 instructs the view to load the given @WALMobileSdkUrl

 @param mobileSdkUrl the sdkUrl from which to create the end url
 @param paymentMethodId the paymentMethodId to use for url creation
 */
- (void)loadPaymentView:(WALMobileSdkUrl *)mobileSdkUrl forPaymentMethodId:(NSUInteger)paymentMethodId;

NS_ASSUME_NONNULL_END
@end
