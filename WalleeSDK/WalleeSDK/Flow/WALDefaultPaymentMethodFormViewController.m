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
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation WALDefaultPaymentMethodFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.theme.primaryBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.submitButton];
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
    [self.paymentFormView loadPaymentView:self.mobileSdkUrl];
}

- (CGRect)defaultPaymentRect {
    CGRect bounds = self.view.bounds;
    CGRect paymentRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height - self.submitButton.frame.size.height);
    return paymentRect;
}

- (CGRect)defaultButtonRect {
    CGRect bounds = self.view.bounds;
    return CGRectMake(bounds.origin.x, bounds.size.height - 44.0f, bounds.size.width, 44.0f);
}

- (WALDefaultPaymentFormView *)paymentFormView {
    if (!_paymentFormView) {
        
        _paymentFormView = [[WALDefaultPaymentFormView alloc] initWithFrame:[self defaultPaymentRect]];
        _paymentFormView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _paymentFormView.delegate = self;
    }
    return _paymentFormView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _submitButton.frame = [self defaultButtonRect];
        _submitButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_submitButton setTitle:WALLocalizedString(@"Submit", @"title of the submit button on the payment method form") forState:UIControlStateNormal];
        _submitButton.backgroundColor = self.theme.accentBackgroundColor;
        [_submitButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _backButton.frame = [self defaultButtonRect];
        _backButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        [_backButton setTitle:WALLocalizedString(@"Submit", @"title of the submit button on the payment method form") forState:UIControlStateNormal];
        _backButton.backgroundColor = self.theme.accentBackgroundColor;
        [_backButton setTitleColor:self.theme.accentColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(submitTaped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

// MARK: - WALPaymentForm Navigation Controls Delegate
- (UIView *)navigationControlView {
    return self.submitButton;
}

// MARK: - WALPaymentForm Delegation
-(void)paymentViewRequestsExpand {
    
}

- (void)paymentViewDidChangeContentSize:(CGSize)size {
    CGRect buttonDefaultRect = [self defaultButtonRect];
    if (size.height < buttonDefaultRect.origin.y) {
        self.paymentFormView.scrollingEnabled = NO;
        self.paymentFormView.frame = CGRectMake(self.paymentFormView.frame.origin.x, self.paymentFormView.frame.origin.y, self.paymentFormView.frame.size.width, size.height);
        self.submitButton.frame = CGRectMake(buttonDefaultRect.origin.x, size.height, buttonDefaultRect.size.width, buttonDefaultRect.size.height);
    } else {
        self.paymentFormView.scrollingEnabled = YES;
        self.paymentFormView.frame = [self defaultPaymentRect];
        self.submitButton.frame = [self defaultButtonRect];
    }
}

- (void)paymentViewRequestsReset {
    
}

- (void)viewDidStartLoading:(UIView *)viewController {
    [self.delegate viewDidStartLoading:viewController];
}

- (void)viewDidFinishLoading:(UIView *)viewController {
    [self.delegate viewDidFinishLoading:viewController];
}

- (void)paymentViewDidValidateSuccessful:(UIViewController *)viewController {
    NSLog(@"VALID");
    [self.delegate paymentViewDidValidateSuccessful:viewController];
}

- (void)paymentView:(UIViewController *)viewController didFailValidationWithErrors:(NSArray<NSError *> *)errors {
    NSLog(@"INVALID");
    [self.delegate paymentView:viewController didFailValidationWithErrors:errors];
}
- (void)paymentView:(UIViewController *)viewController didEncounterError:(NSError *)error {
    [self.delegate paymentView:viewController didEncounterError:error];
}

- (void)paymentViewAwaitsFinalState:(UIViewController *)viewController {
    [self.delegate paymentViewAwaitsFinalState:viewController];
}

- (void)paymentViewDidSucceed:(UIViewController *)viewController {
    [self.delegate paymentViewDidSucceed:viewController];
}

- (void)paymentViewDidFail:(UIViewController *)viewController {
    [self.delegate paymentViewDidFail:viewController];
}

- (void)viewControllerDidExpire:(UIViewController *)viewController {
    [self.delegate viewControllerDidExpire:viewController];
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



@end

// MARK: - Resizing
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    static CGFloat contentHeight = 0.0;
//    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"]) {
//
//        UIScrollView *webScrollView = self.webView.scrollView;
//        CGFloat newContentHeight = webScrollView.contentSize.height;
//        NSLog(@"New contentSize: %f x %f", webScrollView.contentSize.width, newContentHeight);
//        if (contentHeight == newContentHeight) {
//            return;
//        }
//        contentHeight = newContentHeight;
////        self.webView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, newContentHeight);
//        self.paymentFormView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+30.0f, self.view.bounds.size.width, self.view.bounds.size.height - 30.0f);
////        self.submitButton.frame = CGRectMake(self.scrollView.bounds.origin.x, self.webView.frame.size.height, self.scrollView.bounds.size.width, 30.0f);
//        self.submitButton.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 30.0f);
//        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.paymentFormView.frame.size.height+self.submitButton.frame.size.height);
//    }
//}
