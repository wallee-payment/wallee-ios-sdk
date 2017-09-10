//
//  WALDefaultBaseViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 10.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WALDefaultTheme;

@interface WALDefaultBaseViewController : UIViewController
/**
 The theme to be used by all default viewcontroller
 */
@property (nonatomic, copy) WALDefaultTheme *theme;
@end
