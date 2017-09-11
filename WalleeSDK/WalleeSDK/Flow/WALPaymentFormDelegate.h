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

@protocol WALPaymentFormDelegate <NSObject, WALLoadingViewDelegate, WALExpiringViewDelegate>
- (void)paymentViewDidChangeContentSize:(CGSize)size;
- (void)paymentViewRequestsExpand;
- (void)paymentViewRequestsReset;
- (void)paymentViewDidRequestChangePaymentMethod;
- (void)paymentViewDidValidateSuccessful:(UIViewController *)viewController;
- (void)paymentView:(UIViewController *)viewController didFailValidationWithErrors:(NSArray<NSError *> *)errors;
- (void)paymentViewDidSucceed:(UIViewController *)viewController;
- (void)paymentViewDidFail:(UIViewController *)viewController;
- (void)paymentViewAwaitsFinalState:(UIViewController *)viewController;
- (void)paymentView:(UIViewController *)viewController didEncounterError:(NSError *)error;
@end
