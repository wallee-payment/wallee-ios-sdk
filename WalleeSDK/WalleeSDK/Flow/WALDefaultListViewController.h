//
//  WALDefaultListViewViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Supplies a Scrollview to which content can be added.
 Usefull to display @c UITableViews with added content like a @c UIButton below
 */
@interface WALDefaultListViewController : UIViewController
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, strong, readonly) UIButton *submitButton;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (CGSize)contentSize;

- (NSString *)confirmationTitle;
- (void)confirmationTapped:(id)sender;
NS_ASSUME_NONNULL_END
@end
