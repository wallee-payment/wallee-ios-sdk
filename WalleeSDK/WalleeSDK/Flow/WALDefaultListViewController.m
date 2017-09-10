//
//  WALDefaultListViewViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultListViewController.h"
#import "WALDefaultTheme.h"

@interface WALDefaultListViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *confirmationButton;
@end

static const CGFloat confirmationButtonPadding = 10.0f;

@implementation WALDefaultListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    
//    _scrollView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0.0, self.bottomLayoutGuide.length, 0.0);
    
    [self addSubviewsToContentView:self.scrollView];
    [self addConfirmationButton];
    self.scrollView.contentSize = [self contentSizeWithConfirmationButton];
}

- (void)addSubviewsToContentView:(UIView *)contentView {
}

- (CGSize)contentSize {
    return self.view.bounds.size;
}

- (CGSize)contentSizeWithConfirmationButton {
    return CGSizeMake(self.contentSize.width, self.confirmationButton.frame.origin.y + self.confirmationButton.frame.size.height);
}

- (NSString *)confirmationTitle {
    return @"none";
}

- (void)addConfirmationButton {
    CGRect buttonRect = CGRectMake(self.scrollView.bounds.origin.x, self.contentSize.height + confirmationButtonPadding, self.view.bounds.size.width, 44.0);
    self.confirmationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmationButton.frame = buttonRect;
    self.confirmationButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.confirmationButton setTitle:[self confirmationTitle] forState:UIControlStateNormal];
//    self.confirmationButton.tintColor = [UIButton appearance].tintColor;
    [self.confirmationButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
    self.confirmationButton.backgroundColor = self.theme.accentBackgroundColor;
    [self.confirmationButton addTarget:self action:@selector(confirmationTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.confirmationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)confirmationTapped:(id)sender {}
@end
