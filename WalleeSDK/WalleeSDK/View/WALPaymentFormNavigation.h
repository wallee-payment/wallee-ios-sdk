//
//  WALPaymentFormNavigation.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.12.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WALDefaultTheme;

@protocol WALPaymentFormNavigationDelegate <NSObject>
- (void)backTapped;
- (void)submitTapped;
@end

@interface WALPaymentFormNavigation : UIView
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, weak) id<WALPaymentFormNavigationDelegate> delegate;
@property (nonatomic) BOOL hidesBackButton;
@property (nonatomic) BOOL hidesSubmitButton;

@property (nonatomic, readonly) CGFloat currentNavigationalHeight;

- (instancetype)initWithFrame:(CGRect)frame theme:(WALDefaultTheme *)theme;
- (void)updateFrameForOffset:(CGFloat)offset;
- (void)update;
NS_ASSUME_NONNULL_END
@end
