//
//  WALDefaultPaymentMethodFormViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WALPaymentFormView.h"
#import "WALViewControllerFactory.h"
#import "WALPaymentFormDelegate.h"

@interface WALDefaultPaymentMethodFormViewController : UIViewController<WALPaymentFormView, WALPaymentFormDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSURL *mobileSdkUrl;
@property (nonatomic, weak) id<WALPaymentFormDelegate> delegate;
@property (nonatomic) WALOnBackBlock onBack;
NS_ASSUME_NONNULL_END
@end
