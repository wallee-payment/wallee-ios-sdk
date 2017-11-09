//
//  WALDefaultListViewViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultBaseViewController.h"
@class WALDefaultTheme;

/**
 Supplies a Scrollview to which content can be added.
 Usefull to display @c UITableViews with added content like a @c UIButton below
 */
@interface WALDefaultListViewController : WALDefaultBaseViewController
NS_ASSUME_NONNULL_BEGIN

//@property (nonatomic, strong, readonly) UIButton *submitButton;
//@property (nonatomic, strong, readonly) UIButton *backButton;

@property (nonatomic, readwrite) BOOL hidesBackButton;
@property (nonatomic, readwrite) BOOL hidesConfirmationButton;

- (void)addSubviewsToContentView:(UIView *)contentView;
- (CGSize)contentSize;

- (NSString *)confirmationTitle;
- (void)confirmationTapped:(id)sender;

- (NSString *)backTitle;
- (void)backTapped:(id)sender;
NS_ASSUME_NONNULL_END
@end
