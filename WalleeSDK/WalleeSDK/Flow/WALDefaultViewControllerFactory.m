//
//  WALDefaultViewControllerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultViewControllerFactory.h"

#import "WALDefaultTheme.h"

#import "WALDefaultTokenListViewController.h"

#import "WALDefaultPaymentMethodListViewController.h"
#import "WALDefaultPaymentMethodFormViewController.h"

#import "WALDefaultAwaitingFinalStateViewController.h"
#import "WALDefaultSuccessViewController.h"
#import "WALDefaultFailureViewController.h"


@implementation WALDefaultViewControllerFactory

- (WALDefaultTheme *)theme {
    return _theme ?: [WALDefaultTheme defaultTheme];
}

- (UIViewController *)buildTokenListViewWith:(WALLoadedTokens *)loadedTokens onSelection:(WALTokenVersionSelected)callback onChangePaymentMethod:(WALOnBackBlock)changePaymentMethod {
    WALDefaultTokenListViewController *controller = [[WALDefaultTokenListViewController alloc] init];
    controller.loadedTokens = loadedTokens;
    controller.onTokenSelected = callback;
    controller.onPaymentMethodChange = changePaymentMethod;
    controller.theme = self.theme;
    return controller;
}

- (UIViewController *)buildPaymentMethodListViewWith:(WALLoadedPaymentMethods *)loadedPaymentMethods onSelection:(WALPaymentMethodSelected)callback onBack:(WALOnBackBlock)onBack {
    WALDefaultPaymentMethodListViewController *controller = [[WALDefaultPaymentMethodListViewController alloc] init];
    controller.loadedPaymentMethods = loadedPaymentMethods;
    controller.onPaymentMethodSelected = callback;
    controller.onBack = onBack;
    controller.theme = self.theme;
    return controller;
}

- (UIViewController *)buildPaymentMethodFormViewWithURL:(WALMobileSdkUrl *)mobileSdkUrl paymentMethod:(NSUInteger)paymentMethodId onBack:(WALOnBackBlock)onBack {
    WALDefaultPaymentMethodFormViewController *controller = [[WALDefaultPaymentMethodFormViewController alloc] init];
    controller.mobileSdkUrl = mobileSdkUrl;
    controller.paymentMethodId = paymentMethodId;
    controller.onBack = onBack;
    controller.theme = self.theme;
    controller.hidesBackButton = NO;
    return controller;
}

- (UIViewController *)buildAwaitingFinalStateViewWith:(WALTransaction *)transaction {
    WALDefaultAwaitingFinalStateViewController *controller = [[WALDefaultAwaitingFinalStateViewController alloc] init];
    controller.theme = self.theme;
    return controller;
}

- (UIViewController *)buildSuccessViewWith:(WALTransaction *)transaction {
    WALDefaultSuccessViewController *controller = [[WALDefaultSuccessViewController alloc] init];
    controller.transaction = transaction;
    controller.theme = self.theme;
    return controller;
}

- (UIViewController *)buildFailureViewWith:(WALTransaction *)transaction {
    WALDefaultFailureViewController *controller = [[WALDefaultFailureViewController alloc] init];
    controller.transaction = transaction;
    controller.theme = self.theme;
    return controller;
}

@end
