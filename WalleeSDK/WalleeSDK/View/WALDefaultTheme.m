//
//  WALTheme.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultTheme.h"

static UIColor *WALThemeDefaultPrimaryBackgroundColor;
static UIColor *WALThemeDefaultSecondaryBackgroundColor;
static UIColor *WALThemeDefaultPrimaryForegroundColor;
static UIColor *WALThemeDefaultSecondaryForegroundColor;
static UIColor *WALThemeDefaultAccentColor;
static UIColor *WALThemeDefaultAccentBackgroundColor;
static UIFont  *WALThemeDefaultFont;


@implementation WALDefaultTheme

+ (WALDefaultTheme *)defaultTheme {
    static WALDefaultTheme  *WALThemeDefaultTheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WALThemeDefaultTheme = [[self alloc] init];
    });
    return WALThemeDefaultTheme;
}


+ (void)initialize {
    WALThemeDefaultPrimaryBackgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:243.0f/255.0f alpha:1];
    WALThemeDefaultSecondaryBackgroundColor = UIColor.whiteColor;
    WALThemeDefaultPrimaryForegroundColor = [UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1];
    WALThemeDefaultSecondaryForegroundColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1];
    WALThemeDefaultAccentColor = UIColor.whiteColor;
    WALThemeDefaultAccentBackgroundColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1 alpha:1];
    WALThemeDefaultFont = [UIFont systemFontOfSize:17];
}

- (UIColor *)primaryColor {
    return _primaryColor ?: WALThemeDefaultPrimaryForegroundColor;
}

- (UIColor *)secondaryColor {
    return _secondaryColor ?: WALThemeDefaultSecondaryForegroundColor;
}

- (UIColor *)primaryBackgroundColor {
    return _primaryBackgroundColor ?: WALThemeDefaultPrimaryBackgroundColor;
}

- (UIColor *)secondaryBackgroundColor {
    return _secondaryBackgroundColor ?: WALThemeDefaultSecondaryBackgroundColor;
}

- (UIFont *)font {
    return _font ?: WALThemeDefaultFont;
}

- (UIColor *)accentColor {
    return _accentColor ?: WALThemeDefaultAccentColor;
}

- (UIColor *)accentBackgroundColor {
    return _accentBackgroundColor ?: WALThemeDefaultAccentBackgroundColor;
}


// MARK: - Copying
- (id)copyWithZone:(NSZone *)zone {
    WALDefaultTheme *theme = [[self.class allocWithZone:zone] init];
    theme->_accentColor = _accentColor.copy;
    theme->_primaryColor = _primaryColor.copy;
    theme->_primaryBackgroundColor = _primaryBackgroundColor.copy;
    theme->_secondaryColor = _secondaryColor.copy;
    theme->_secondaryBackgroundColor = _secondaryBackgroundColor.copy;
    theme->_font = _font.copy;
    return theme;
}
@end
