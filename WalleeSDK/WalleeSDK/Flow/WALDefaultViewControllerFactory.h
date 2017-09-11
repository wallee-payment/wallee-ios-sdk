//
//  WALDefaultViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALViewControllerFactory.h"
@class WALDefaultTheme;

@interface WALDefaultViewControllerFactory : NSObject<WALViewControllerFactory>
@property (nonatomic, copy, null_resettable) WALDefaultTheme *theme;
@end
