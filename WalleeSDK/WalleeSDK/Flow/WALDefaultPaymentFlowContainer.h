//
//  WALDefaultFlowViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALPaymentFlowContainer.h"
#import "WALPaymentFlowContainerFactory.h"

/**
 Default implementation of a @c WALPaymentFlowContainer.
 uses a @c UINavigationController internaly to display the flow
 */
@interface WALDefaultPaymentFlowContainer : UINavigationController<UINavigationBarDelegate, WALPaymentFlowContainer>
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController backAction:(WALContainerBackAction)onBackAction;

- (UIView *)loadingView;
@end
