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
@class WALDefaultTheme;

/**
 Default implementation of a @c WALPaymentFlowContainer.
 uses a @c UINavigationController internaly to display the flow
 */
@interface WALDefaultPaymentFlowContainer : UINavigationController<UINavigationBarDelegate, WALPaymentFlowContainer>

@property (nonatomic, copy, null_resettable) WALDefaultTheme *theme;

- (instancetype _Nonnull )initWithRootViewController:(UIViewController *_Nonnull)rootViewController backAction:(WALContainerBackAction _Nullable )onBackAction;

- (UIView *_Nonnull)loadingView;
@end
