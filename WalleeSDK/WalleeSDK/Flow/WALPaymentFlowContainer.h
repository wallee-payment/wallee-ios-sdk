//
//  WALPaymentFlowViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A WALPaymentFlowContainer is used to display all payment flow related views and as such has to be displayed
 in the integrating Application.
 
 */
@protocol WALPaymentFlowContainer <NSObject>
/**
 this is called when a state requests its viewcontroller to be presented

 @param viewController the viewController to present
 */
- (void)displayViewController:(UIViewController * _Nonnull)viewController;

/**
 this is called when the any processing or loading is done. as such the implementor should display
 an indication of processing.
 */
- (void)displayLoading;


/**
 this method should return the currently displayed viewController

 @return currently displayed viewController
 */
- (UIViewController * _Nonnull)currentlyDisplayedViewController;
/**
 Must return the @c UIViewController into which all Views are rendered.
 <p>
 The implementing app should display the UIView @c viewController.view somewhere in its hierarchy.
 eg in a present it as a modal view controller
 </p>
 @return the UIViewController displaying the PaymentFlowViews
 */
- (UIViewController *_Nonnull)viewController;
@end
