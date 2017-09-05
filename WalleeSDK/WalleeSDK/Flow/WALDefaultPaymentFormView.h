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

@interface WALDefaultPaymentFormView : UIView<WALPaymentFormView, WKNavigationDelegate, WKScriptMessageHandler>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL isSubmitted;
/**
 Defaults to true.
 if disabled the internal webView will disable scrolling and set its frame to its content size.
 you should then observe @c defaultPaymentFragment.contentSize and adapt your ViewController Layout accordingly.
 */
@property (nonatomic) BOOL scrollingEnabled;
/**
 the contens size of the loaded @c NSURL
 */
@property (nonatomic, readonly) CGSize contentSize;

- (void)loadPaymentView:(NSURL *)mobileSdkUrl;
NS_ASSUME_NONNULL_END
@end
