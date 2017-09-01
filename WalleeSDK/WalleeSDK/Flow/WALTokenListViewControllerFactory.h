//
//  WALTokenListViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTokenVersion, UIViewController;
#import "WALTokenListViewController.h"

@protocol WALTokenListViewControllerFactory <NSObject>
- (UIViewController<WALTokenListViewController> *_Nonnull)buildWith:(NSArray<WALTokenVersion *> *_Nonnull)tokens onSelection:(WALTokenVersionSelected _Nullable )callback;
@end
