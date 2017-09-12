//
//  WALDefaultPaymentMethodFormViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentMethodFormViewController.h"
#import "WALDefaultPaymentFormView.h"

#import "WALDefaultTheme.h"
#import "WALTranslation.h"

@interface WALDefaultPaymentMethodFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WALDefaultPaymentFormView *paymentFormView;
@property (nonatomic, strong) UIView *navigationalView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *backButton;
@end


static CGFloat contentPadding = 10.0f;
static CGFloat defaultButtonHeight = 44.0f;

@implementation WALDefaultPaymentMethodFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.theme.primaryBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.navigationalView];
    [self.view addSubview:self.paymentFormView];
    
//            self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.test.frame.size.height, 0);
//            self.webView.scrollView.contentOffset = CGPointMake(0, self.test.frame.size.height);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = self.topLayoutGuide.length;
    self.paymentFormView.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, self.bottomLayoutGuide.length, 0);
    self.paymentFormView.webView.scrollView.contentInset = UIEdgeInsetsMake(top, 0, self.bottomLayoutGuide.length, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentFormView loadPaymentView:self.mobileSdkUrl forPaymentMethodId:self.paymentMethodId];
}

- (CGRect)defaultPaymentRect {
    CGRect bounds = self.view.bounds;
    CGRect paymentRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height - [self defaultNavigationalRect].size.height);
    return paymentRect;
}

- (CGRect)defaultNavigationalRect {
    CGRect bounds = self.view.bounds;
    CGFloat height = self.hidesBackButton ? defaultButtonHeight : 2 * defaultButtonHeight + contentPadding;
    return CGRectMake(bounds.origin.x, bounds.size.height - height, bounds.size.width, height);
}

- (WALDefaultPaymentFormView *)paymentFormView {
    if (!_paymentFormView) {
        
        _paymentFormView = [[WALDefaultPaymentFormView alloc] initWithFrame:[self defaultPaymentRect]];
        _paymentFormView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _paymentFormView.delegate = self;
    }
    return _paymentFormView;
}

- (UIView *)navigationalView {
    if (!_navigationalView) {
        _navigationalView = [[UIView alloc] initWithFrame:[self defaultNavigationalRect]];
        _navigationalView.backgroundColor = self.theme.primaryBackgroundColor;
        [_navigationalView addSubview:self.submitButton];
        [_navigationalView addSubview:self.backButton];
    }
    return _navigationalView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _submitButton.frame = CGRectMake(0.0f, 0.0f, [self defaultNavigationalRect].size.width, defaultButtonHeight);
        _submitButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_submitButton setTitle:WALLocalizedString(@"payment_form_submit", @"title of the submit button on the payment method form") forState:UIControlStateNormal];
        _submitButton.backgroundColor = self.theme.accentBackgroundColor;
        [_submitButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backButton.frame = CGRectMake(0.0f, defaultButtonHeight + contentPadding, [self defaultNavigationalRect].size.width, defaultButtonHeight);
        _backButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_backButton setTitle:WALLocalizedString(@"payment_form_change_method", @"title of the back button on the payment method form") forState:UIControlStateNormal];
        _backButton.backgroundColor = self.theme.accentBackgroundColor;
        [_backButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

// MARK: - WALPaymentForm Navigation Controls Delegate
- (UIView *)navigationControlView {
    return self.submitButton;
}

// MARK: - WALPaymentForm Delegation
-(void)paymentViewRequestsExpand {
    
}

- (void)paymentViewDidChangeContentSize:(CGSize)size {
    CGRect buttonDefaultRect = [self defaultNavigationalRect];
    if (size.height < buttonDefaultRect.origin.y) {
        self.paymentFormView.scrollingEnabled = NO;
        self.paymentFormView.frame = CGRectMake(self.paymentFormView.frame.origin.x, self.paymentFormView.frame.origin.y, self.paymentFormView.frame.size.width, size.height);
        self.navigationalView.frame = CGRectMake(buttonDefaultRect.origin.x, size.height, buttonDefaultRect.size.width, buttonDefaultRect.size.height);
    } else {
        self.paymentFormView.scrollingEnabled = YES;
        self.paymentFormView.frame = [self defaultPaymentRect];
        self.navigationalView.frame = [self defaultNavigationalRect];
    }
}

- (void)paymentViewRequestsReset {
    
}

- (void)viewDidStartLoading:(UIView *)viewController {
    self.navigationalView.hidden = YES;
    [self.delegate viewDidStartLoading:viewController];
}

- (void)viewDidFinishLoading:(UIView *)viewController {
    self.navigationalView.hidden = NO;
    [self.delegate viewDidFinishLoading:viewController];
}

- (void)paymentViewDidValidateSuccessful {
    [self.delegate paymentViewDidValidateSuccessful];
}

- (void)paymentViewDidFailValidationWithErrors:(NSArray<NSError *> *)errors {
    [self.delegate paymentViewDidFailValidationWithErrors:errors];
}
- (void)paymentViewDidEncounterError:(NSError *)error {
    [self.delegate paymentViewDidEncounterError:error];
}

- (void)paymentViewAwaitsFinalState {
    [self.delegate paymentViewAwaitsFinalState];
}

- (void)paymentViewDidSucceed {
    [self.delegate paymentViewDidSucceed];
}

- (void)paymentViewDidFail {
    [self.delegate paymentViewDidFail];
}

- (void)viewControllerDidExpire:(UIViewController *)viewController {
    [self.delegate viewControllerDidExpire:viewController];
}

- (void)paymentViewDidRequestChangePaymentMethod {
    [self.delegate paymentViewDidRequestChangePaymentMethod];
}

// MARK: - PaymentForm Protocol
- (BOOL)isSubmitted {
    return self.paymentFormView.isSubmitted;
}

- (void)validate {
    return [self.paymentFormView validate];
}

- (void)submit {
    return [self.paymentFormView submit];
}

- (void)submitTaped {
    [self.paymentFormView validate];
}

- (void)backTaped {
    [self.delegate paymentViewDidRequestChangePaymentMethod];
}

@end
