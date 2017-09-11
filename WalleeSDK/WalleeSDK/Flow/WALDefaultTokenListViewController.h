//
//  WALDefaultTokenListViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALViewControllerFactory.h"
#import "WALDefaultListViewController.h"

@class WALLoadedTokens, WALDefaultTheme;

@interface WALDefaultTokenListViewController : WALDefaultListViewController<UITableViewDelegate, UITableViewDataSource>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALLoadedTokens *loadedTokens;
@property (nonatomic) WALTokenVersionSelected onTokenSelected;
@property (nonatomic) WALOnBackBlock onPaymentMethodChange;
NS_ASSUME_NONNULL_END
@end
