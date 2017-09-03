//
//  WALPaymentFlowViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WALPaymentFlowContainer <NSObject>
- (void)displayViewController:(UIViewController * _Nonnull)viewController;
- (void)displayLoading;

/**
 Must return the @c UIViewController into which all Views are rendered.
 The implementing app should display the UIView @c viewController.view somewhere in its hierarchy

 @return the UIViewController displaying the PaymentFlowViews
 */
- (UIViewController *_Nonnull)viewController;
@end
