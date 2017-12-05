//
//  WALPaymentFormNavigation.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.12.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentFormNavigation.h"
#import "WALDefaultTheme.h"
#import "WALTranslation.h"

@interface WALPaymentFormNavigation ()
@property (nonatomic, copy) WALDefaultTheme *theme;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *backButton;
@end

static CGFloat contentPadding = 10.0f;
static CGFloat defaultButtonHeight = 44.0f;

@implementation WALPaymentFormNavigation

- (instancetype)initWithFrame:(CGRect)frame theme:(WALDefaultTheme *)theme {
    CGRect rect = CGRectMake(frame.origin.x,
                             frame.origin.y,
                             frame.size.width,
                             2*defaultButtonHeight + contentPadding);
    if (self = [super initWithFrame:rect]) {
        self.theme = theme;
        self.backgroundColor = self.theme.primaryBackgroundColor;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        
        [self addSubview:self.submitButton];
        [self addSubview:self.backButton];
    }
    return self;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(0.0f, 0.0f, [self currentNavigationalRect].size.width, defaultButtonHeight);
        _submitButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_submitButton setTitle:WALLocalizedString(@"payment_form_submit", @"title of the submit button on the payment method form") forState:UIControlStateNormal];
        _submitButton.backgroundColor = self.theme.accentBackgroundColor;
        [_submitButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backButton.frame = CGRectMake(0.0f, defaultButtonHeight + contentPadding, [self currentNavigationalRect].size.width, defaultButtonHeight);
        _backButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_backButton setTitle:WALLocalizedString(@"payment_form_change_method", @"title of the back button on the payment method form") forState:UIControlStateNormal];
        _backButton.backgroundColor = self.theme.accentBackgroundColor;
        [_backButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CGFloat)currentBackButtonHeight {
    return self.hidesBackButton ? 0.0 : defaultButtonHeight;
}

- (CGFloat)currentSubmitButtonHeight {
    return self.hidesSubmitButton ? 0.0 : defaultButtonHeight;
}

- (CGRect)currentNavigationalRect {
    return self.frame;
}

- (void)updateViewSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self currentNavigationalHeight]);
}

- (void)updateFrameForOffset:(CGFloat)offset {
    [self update];
    self.frame = CGRectMake(self.frame.origin.x, offset, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)currentNavigationalHeight {
    CGFloat height = self.currentSubmitButtonHeight + self.currentBackButtonHeight;
    height = height > defaultButtonHeight ? height + contentPadding : height;
    return height;
}

- (CGFloat)heightWithNavigationForContentHeight:(CGFloat)height {
    return height + [self currentNavigationalRect].size.height;
}

- (void)update {
    self.submitButton.hidden = self.hidesSubmitButton;
    self.backButton.hidden = self.hidesBackButton;
    [self updateViewSize];
    self.submitButton.frame = CGRectMake(0.0f, 0.0f, [self currentNavigationalRect].size.width, defaultButtonHeight);
    if (self.hidesSubmitButton) {
        self.backButton.frame = self.submitButton.frame;
    } else {
        self.backButton.frame = CGRectMake(0.0f, defaultButtonHeight + contentPadding, [self currentNavigationalRect].size.width, defaultButtonHeight);
    }
}

// MARK: - Delegate
- (void)buttonTapped:(UIButton*)sender {
    if (sender == self.backButton && [self.delegate respondsToSelector:@selector(backTapped)]) {
        [self.delegate backTapped];
    } else if(sender == self.submitButton && [self.delegate respondsToSelector:@selector(submitTapped)]) {
        [self.delegate submitTapped];
    }
}

@end
