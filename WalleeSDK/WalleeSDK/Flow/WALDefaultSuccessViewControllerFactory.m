//
//  WALDefaultSuccessViewControllerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultSuccessViewControllerFactory.h"
#import "WALDefaultSuccessViewController.h"

@implementation WALDefaultSuccessViewControllerFactory

-(UIViewController *)buildWithTransaction:(WALTransaction *)transaction {
    WALDefaultSuccessViewController *controller = [[WALDefaultSuccessViewController alloc] init];
    controller.transaction = transaction;
    return controller;
}

@end
