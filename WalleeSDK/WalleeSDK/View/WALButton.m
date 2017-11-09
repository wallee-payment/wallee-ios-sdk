//
//  WALButton.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 10.11.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALButton.h"
#import "WALDefaultTheme.h"

const CGFloat WALButtonDefaultHeight = 44.0;
const CGFloat WALButtonContentPadding = 10.0f;

@implementation WALButton

+ (UIButton *)buttonWithTheme:(WALDefaultTheme *)theme andRect:(CGRect)rect {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitleColor:theme.accentColor forState:UIControlStateNormal];
    button.backgroundColor = theme.accentBackgroundColor;
    return button;
}

@end
