//
//  WALDefaultFlowViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentFlowContainer.h"

@interface WALDefaultPaymentFlowContainer ()
@property (nonatomic, strong) UIView *activityIndicatorBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation WALDefaultPaymentFlowContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator startAnimating];
    
    self.activityIndicatorBackgroundView = [[UIView alloc] initWithFrame:self.activityIndicator.bounds];
    self.activityIndicatorBackgroundView.backgroundColor = [UIColor greenColor];
    [self.activityIndicatorBackgroundView addSubview:self.activityIndicator];
}

- (void)displayViewController:(UIViewController *)viewController {
    [self.activityIndicatorBackgroundView removeFromSuperview];
    if (viewController != self.currentlyDisplayedViewController) {
        [self pushViewController:viewController animated:YES];
    } else {
        NSLog(@"ViewController already on top of Stack");
    }
}

- (UIViewController *)currentlyDisplayedViewController {
    return self.viewControllers.lastObject;
}

- (void)displayLoading {
    if (!self.activityIndicatorBackgroundView.superview) {
        self.activityIndicatorBackgroundView.center = self.view.center;
        [self.view addSubview:self.activityIndicatorBackgroundView];
    }
}

- (UIViewController *)viewController {
    return self;
}

@end

