//
//  WALDefaultViewControllerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultViewControllerFactory.h"

#import "WALDefaultTokenListViewController.h"
#import "WALDefaultSuccessViewController.h"
#import "WALDefaultFailureViewController.h"


@implementation WALDefaultViewControllerFactory
- (UIViewController *)buildTokenListViewWith:(NSArray<WALTokenVersion *> *)tokens onSelection:(WALTokenVersionSelected)callback {
    WALDefaultTokenListViewController *defaultViewController = [[WALDefaultTokenListViewController alloc] init];
    defaultViewController.tokens = tokens;
    defaultViewController.onTokenSelected = callback;
    return defaultViewController;
}

- (UIViewController *)buildSuccessViewWith:(WALTransaction *)transaction {
    WALDefaultSuccessViewController *controller = [[WALDefaultSuccessViewController alloc] init];
    controller.transaction = transaction;
    return controller;
}

- (UIViewController *)buildFailureViewWith:(WALTransaction *)transaction {
    WALDefaultFailureViewController *controller = [[WALDefaultFailureViewController alloc] init];
    controller.transaction = transaction;
    return controller;
}

@end
