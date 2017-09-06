//
//  WALDefaultPaymentMethodFormViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentMethodFormViewController.h"
#import "WALDefaultPaymentFormView.h"

@interface WALDefaultPaymentMethodFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WALDefaultPaymentFormView *paymentFormView;
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation WALDefaultPaymentMethodFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:self.scrollView];
    CGRect paymentRect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 44.0, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f);

    self.paymentFormView = [[WALDefaultPaymentFormView alloc] initWithFrame:paymentRect];
    self.paymentFormView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.paymentFormView.delegate = self;
    [self.view addSubview:self.paymentFormView];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 44.0f);
    self.submitButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.backgroundColor = UIColor.lightGrayColor;
    [self.submitButton addTarget:self action:@selector(submitTaped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentFormView loadPaymentView:self.mobileSdkUrl];
    
}


// MARK: - WALPaymentForm Delegation

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
    NSLog(@"tapp");
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
