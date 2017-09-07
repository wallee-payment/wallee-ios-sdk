//
//  WALDefaultFlowViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentFlowContainer.h"

@interface WALDefaultPaymentFlowContainer ()
@property (nonatomic, copy) WALContainerBackAction onBackAction;
@property (nonatomic, strong) UIView *activityIndicatorBackgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation WALDefaultPaymentFlowContainer

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController backAction:(WALContainerBackAction)onBackAction {
    if (self = [self initWithRootViewController:rootViewController]) {
        self.onBackAction = onBackAction;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator startAnimating];
    
    self.activityIndicatorBackgroundView = [[UIView alloc] initWithFrame:self.activityIndicator.bounds];
    self.activityIndicatorBackgroundView.backgroundColor = [UIColor greenColor];
    [self.activityIndicatorBackgroundView addSubview:self.activityIndicator];
}

- (void)displayViewController:(UIViewController *)viewController {
     [self.activityIndicatorBackgroundView removeFromSuperview];
    
    
    // if in stack ... replace
    NSMutableArray *rebuiltStack = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count];
    BOOL isInStack = NO;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:viewController.class]) {
            isInStack = YES;
            break;
        } else {
            [rebuiltStack addObject:controller];
        }
    }
    
    if (isInStack) {
        [rebuiltStack addObject:viewController];
        [self setViewControllers:rebuiltStack animated:NO];
        return;
    }
    
    if (viewController != self.currentlyDisplayedViewController) {
        [self pushViewController:viewController animated:NO];
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

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    self.onBackAction();
    return NO;
}

@end

