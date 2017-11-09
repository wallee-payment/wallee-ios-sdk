//
//  WALButton.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 10.11.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WALDefaultTheme;

FOUNDATION_EXPORT const CGFloat WALButtonDefaultHeight;
FOUNDATION_EXPORT const CGFloat WALButtonContentPadding;

@interface WALButton : UIView
+ (UIButton *)buttonWithTheme:(WALDefaultTheme *)theme andRect:(CGRect)rect;
@end
