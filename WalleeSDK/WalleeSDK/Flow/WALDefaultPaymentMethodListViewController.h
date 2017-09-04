//
//  WALDefaultPaymentMethodListViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALViewControllerFactory.h"

@interface WALDefaultPaymentMethodListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSArray<WALPaymentMethodConfiguration *> *paymentMethods;
@property (nonatomic) WALPaymentMethodSelected onPaymentMethodSelected;
NS_ASSUME_NONNULL_END
@end
