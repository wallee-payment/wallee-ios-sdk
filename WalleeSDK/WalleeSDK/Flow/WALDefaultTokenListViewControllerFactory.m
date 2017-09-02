//
//  WALDefaultTokenListViewControllerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultTokenListViewControllerFactory.h"
#import "WALDefaultTokenListViewController.h"

@implementation WALDefaultTokenListViewControllerFactory
- (UIViewController<WALTokenListViewController> *)buildWith:(NSArray<WALTokenVersion *> *)tokens onSelection:(WALTokenVersionSelected)callback {
    WALDefaultTokenListViewController *defaultViewController = [[WALDefaultTokenListViewController alloc] init];
    defaultViewController.onTokenSelected = callback;
    return defaultViewController;
}
@end
