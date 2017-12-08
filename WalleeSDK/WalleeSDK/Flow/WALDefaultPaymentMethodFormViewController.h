//
//  WALDefaultPaymentMethodFormViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "WALDefaultBaseViewController.h"
#import "WALViewControllerFactory.h"

#import "WALPaymentFormView.h"
#import "WALPaymentFormDelegate.h"
#import "WALDefaultPaymentFormView.h"
#import "WALPaymentFormNavigation.h"

@class WALMobileSdkUrl;

@interface WALDefaultPaymentMethodFormViewController : WALDefaultBaseViewController<WALPaymentFormView, WALPaymentFormDelegate, WALPaymentFormNavigationDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALMobileSdkUrl *mobileSdkUrl;
@property (nonatomic) NSUInteger paymentMethodId;
@property (nonatomic, copy) NSString *paymentMethodName;
@property (nonatomic, weak) id<WALPaymentFormDelegate> delegate;
@property (nonatomic) WALOnBackBlock onBack;

/**
 You can controll the display of the on view backButton with this property
 */
@property (nonatomic) BOOL hidesBackButton;
@property (nonatomic) BOOL hidesSubmitButton;
NS_ASSUME_NONNULL_END
@end
