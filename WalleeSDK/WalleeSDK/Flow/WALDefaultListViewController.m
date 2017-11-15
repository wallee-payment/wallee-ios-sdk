//
//  WALDefaultListViewViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultListViewController.h"
#import "WALDefaultTheme.h"
#import "WALButton.h"

@interface WALDefaultListViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *navigationView;
//@property (nonatomic, strong) UIButton *confirmationButton;
//@property (nonatomic, strong) UIButton *backButton;
@end

@implementation WALDefaultListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    
    [self addSubviewsToContentView:self.scrollView];
    self.navigationView = [self createNavigationView];
    if (self.navigationView) {
        [self.scrollView addSubview:self.navigationView];
    }
    
    self.scrollView.contentSize = [self contentSizeWithNavigationView];
}


- (void)addSubviewsToContentView:(UIView *)contentView {
}

- (CGSize)contentSize {
    return self.view.bounds.size;
}

- (CGSize)contentSizeWithNavigationView {
    return CGSizeMake(self.contentSize.width, self.navigationView.frame.origin.y + self.navigationView.frame.size.height);
}

- (UIView *)createNavigationView {
    if (self.hidesConfirmationButton && self.hidesBackButton) {
        return nil;
    }
    
    CGFloat height = self.hidesConfirmationButton ? 0.0 : WALButtonDefaultHeight;
    if (!self.hidesBackButton) {
        if (height > 0.0) {
            height += WALButtonContentPadding;
        }
        height += WALButtonDefaultHeight;
    }
    CGRect rect = CGRectMake(self.scrollView.bounds.origin.x,
                             self.contentSize.height + WALButtonContentPadding,
                             self.view.bounds.size.width,
                             height);
    UIView *navigationView = [[UIView alloc] initWithFrame:rect];
    navigationView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    if (!self.hidesConfirmationButton) {
        [navigationView addSubview:[self createConfirmationButton]];
    }
    if (!self.hidesBackButton) {
        [navigationView addSubview:[self createBackButton]];
    }
    return navigationView;
}

- (NSString *)confirmationTitle {
    return @"";
}

- (NSString *)backTitle {
    return @"";
}

- (UIButton *)createConfirmationButton {
    CGRect buttonRect = CGRectMake(0.0, 0.0, self.view.bounds.size.width, WALButtonDefaultHeight);
    UIButton *button = [WALButton buttonWithTheme:self.theme andRect:buttonRect];
    [button setTitle:[self confirmationTitle] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmationTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)createBackButton {
    CGFloat yStart = self.hidesConfirmationButton ? 0.0 : WALButtonDefaultHeight + WALButtonContentPadding;
    CGRect buttonRect = CGRectMake(0.0, yStart, self.view.bounds.size.width, WALButtonDefaultHeight);
    UIButton *button = [WALButton buttonWithTheme:self.theme andRect:buttonRect];
    [button setTitle:[self backTitle] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmationTapped:(id)sender {}
- (void)backTapped:(id)sender {}

@end
