//
//  WALDefaultFlowViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WALDefaultPaymentFlowContainer.h"

@interface WALDefaultPaymentFlowContainer ()
@property (nonatomic, copy) WALContainerBackAction onBackAction;
@property (nonatomic, strong) UIView *loadingViewContainer;
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
}

- (UIView *)loadingView {

    if (!self.loadingViewContainer) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.activityIndicator startAnimating];
        
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//        UIVibrancyEffect *fibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
//        UIVisualEffectView *effectView =[[UIVisualEffectView alloc] initWithEffect:fibrancy];
        
        CGFloat width = self.activityIndicator.frame.size.width + 10.0;
        self.loadingViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, width)];
        self.loadingViewContainer.layer.cornerRadius = width/2;
        self.loadingViewContainer.layer.masksToBounds = YES;
        self.loadingViewContainer.backgroundColor = [UIColor lightGrayColor];

        [self.loadingViewContainer addSubview:self.activityIndicator];
        self.activityIndicator.center = self.loadingViewContainer.center;
    }
    return self.loadingViewContainer;
}

- (void)displayViewController:(UIViewController *)viewController {
     [self.loadingView removeFromSuperview];
    
    
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
    if (!self.loadingView.superview) {
        self.loadingView.center = self.view.center;
        [self.view addSubview:self.loadingView];
    }
}

- (UIViewController *)viewController {
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.loadingView.center = self.view.center;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    self.onBackAction();
    return NO;
}

@end

