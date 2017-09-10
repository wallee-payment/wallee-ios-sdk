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

@interface WALDefaultPaymentMethodFormViewController : WALDefaultBaseViewController<WALPaymentFormView, WALPaymentFormDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSURL *mobileSdkUrl;
@property (nonatomic, weak) id<WALPaymentFormDelegate> delegate;
@property (nonatomic) WALOnBackBlock onBack;
NS_ASSUME_NONNULL_END
@end
