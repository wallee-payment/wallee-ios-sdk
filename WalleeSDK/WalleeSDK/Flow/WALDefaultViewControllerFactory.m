//
//  WALDefaultViewControllerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultViewControllerFactory.h"

#import "WALDefaultTokenListViewController.h"

#import "WALDefaultPaymentMethodListViewController.h"
#import "WALDefaultPaymentMethodFormViewController.h"

#import "WALDefaultAwaitingFinalStateViewController.h"
#import "WALDefaultSuccessViewController.h"
#import "WALDefaultFailureViewController.h"


@implementation WALDefaultViewControllerFactory
- (UIViewController *)buildTokenListViewWith:(WALLoadedTokens *)loadedTokens onSelection:(WALTokenVersionSelected)callback onChangePaymentMethod:(WALOnBackBlock)changePaymentMethod {
    WALDefaultTokenListViewController *controller = [[WALDefaultTokenListViewController alloc] init];
    controller.loadedTokens = loadedTokens;
    controller.onTokenSelected = callback;
    controller.onPaymentMethodChange = changePaymentMethod;
    return controller;
}

- (UIViewController *)buildPaymentMethodListViewWith:(WALLoadedPaymentMethods *)loadedPaymentMethods onSelection:(WALPaymentMethodSelected)callback onBack:(WALOnBackBlock)onBack {
    WALDefaultPaymentMethodListViewController *controller = [[WALDefaultPaymentMethodListViewController alloc] init];
    controller.loadedPaymentMethods = loadedPaymentMethods;
    controller.onPaymentMethodSelected = callback;
    controller.onBack = onBack;
    return controller;
}

- (UIViewController *)buildPaymentMethodFormViewWithURL:(NSURL *)mobileSdkUrl onBack:(WALOnBackBlock)onBack {
    WALDefaultPaymentMethodFormViewController *controller = [[WALDefaultPaymentMethodFormViewController alloc] init];
    controller.mobileSdkUrl = mobileSdkUrl;
    controller.onBack = onBack;
    return controller;
}

- (UIViewController *)buildAwaitingFinalStateViewWith:(WALTransaction *)transaction {
    WALDefaultAwaitingFinalStateViewController *controller = [[WALDefaultAwaitingFinalStateViewController alloc] init];
    return controller;
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
