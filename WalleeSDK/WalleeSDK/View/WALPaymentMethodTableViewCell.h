//
//  WALPaymentMethodTableViewCell.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WALPaymentMethodIcon;

@interface WALPaymentMethodTableViewCell : UITableViewCell
NS_ASSUME_NONNULL_BEGIN
+ (CGFloat)defaultCellHeight;
- (void)configureWith:(NSString *)paymentMethod paymentIcon:(WALPaymentMethodIcon * _Nullable)paymentIcon;
NS_ASSUME_NONNULL_END
@end
