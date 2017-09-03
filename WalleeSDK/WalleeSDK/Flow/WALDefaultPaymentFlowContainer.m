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
    self.activityIndicatorBackgroundView.hidden = YES;
    
//    s[self.view addSubview:self.activityIndicatorBackgroundView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayViewController:(UIViewController *)viewController {
    self.activityIndicatorBackgroundView.hidden = YES;
    [self pushViewController:viewController animated:YES];

}

- (void)displayLoading {
    self.activityIndicatorBackgroundView.hidden = NO;
}

- (UIViewController *)viewController {
    return self;
}

@end


//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    NSAssert(false,@"-initWithNibName:bundle: unavailable use -initWithNibName:bundle:configuration: instead");
//    return nil;
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil configuration:(WALFlowConfiguration*)configuration {
//    return nil;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    NSAssert(false,@"InitWithCoder: unavailable use -initWithCoder:configuration: instead");
//    return nil;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder configuration:(WALFlowConfiguration*)configuration {
//    return [super initWithCoder:aDecoder];
//}
//
//+ (instancetype)viewControllerWithConfig:(WALFlowConfiguration *)configuration {
//    return nil;
//}
