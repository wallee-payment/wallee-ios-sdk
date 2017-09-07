//
//  WALTheme.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALTheme.h"

static UIColor *WALThemeDefaultPrimaryBackgroundColor;
static UIColor *WALThemeDefaultSecondaryBackgroundColor;
static UIColor *WALThemeDefaultPrimaryForegroundColor;
static UIColor *WALThemeDefaultSecondaryForegroundColor;
static UIColor *WALThemeDefaultAccentColor;
static UIFont  *WALThemeDefaultFont;


@implementation WALTheme

+ (WALTheme *)defaultTheme {
    static WALTheme  *WALThemeDefaultTheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WALThemeDefaultTheme = [[self alloc] init];
    });
    return WALThemeDefaultTheme;
}


+ (void)initialize {
    WALThemeDefaultPrimaryBackgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:245.0f/255.0f alpha:1];
    WALThemeDefaultSecondaryBackgroundColor = [UIColor whiteColor];
    WALThemeDefaultPrimaryForegroundColor = [UIColor colorWithRed:43.0f/255.0f green:43.0f/255.0f blue:45.0f/255.0f alpha:1];
    WALThemeDefaultSecondaryForegroundColor = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1];
    WALThemeDefaultAccentColor = [UIColor colorWithRed:0 green:122.0f/255.0f blue:1 alpha:1];
    WALThemeDefaultFont = [UIFont systemFontOfSize:17];
}

@end
