//
//  WALTheme.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This Theme is used by the different WALDefaultViewControllers and gives a
 convenience to style them.
 */
@interface WALDefaultTheme : NSObject<NSCopying>

+ (WALDefaultTheme * _Nonnull)defaultTheme;

/**
 The primary Color used for Text etc.
 */
@property (nonatomic, copy, null_resettable) UIColor* primaryColor;

/**
 The secondary foreground color is primary used eg for Button Text
 */
@property (nonatomic, copy, null_resettable) UIColor* secondaryColor;

/**
 the primary background color used by the root elements of each view
 */
@property (nonatomic, copy, null_resettable) UIColor* primaryBackgroundColor;
/**
 the secondary background color is eg used for call backgrounds and ohter suplementary views
 */
@property (nonatomic, copy, null_resettable) UIColor* secondaryBackgroundColor;
/**
 the accent color is used for buttons
 */
@property (nonatomic, copy, null_resettable) UIColor* accentColor;
@property (nonatomic, copy, null_resettable) UIColor* accentBackgroundColor;
/**
 the font is primary used for buttons
 */
@property (nonatomic, copy, null_resettable) UIFont *font;
@end
