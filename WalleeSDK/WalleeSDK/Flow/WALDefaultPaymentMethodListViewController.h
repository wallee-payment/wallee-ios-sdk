//
//  WALDefaultPaymentMethodListViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALViewControllerFactory.h"
#import "WALDefaultListViewController.h"

@interface WALDefaultPaymentMethodListViewController : WALDefaultListViewController<UITableViewDelegate, UITableViewDataSource>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) WALLoadedPaymentMethods *loadedPaymentMethods;
@property (nonatomic) WALPaymentMethodSelected onPaymentMethodSelected;
@property (nonatomic) WALOnBackBlock onBack;
NS_ASSUME_NONNULL_END
@end
