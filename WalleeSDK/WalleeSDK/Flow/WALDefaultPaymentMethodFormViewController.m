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
@property (nonatomic, strong) WALPaymentFormNavigation *navigationView;

@property (nonatomic) CGFloat currentContentHeight;
@end

@implementation WALDefaultPaymentMethodFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.theme.primaryBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.currentContentHeight = -1.0;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.paymentFormView];
    
    self.navigationView = [[WALPaymentFormNavigation alloc] initWithFrame:self.view.bounds theme:self.theme];
    self.navigationView.delegate = self;
    [self.scrollView addSubview:self.navigationView];
    [self.scrollView bringSubviewToFront:self.navigationView];
    
    self.title = self.paymentMethodName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paymentFormView loadPaymentView:self.mobileSdkUrl forPaymentMethodId:self.paymentMethodId];
}

- (WALDefaultPaymentFormView *)paymentFormView {
    if (!_paymentFormView) {
        _paymentFormView = [[WALDefaultPaymentFormView alloc] initWithFrame:self.view.bounds];
        _paymentFormView.autoresizingMask = (UIViewAutoresizingFlexibleWidth );
        _paymentFormView.delegate = self;
    }
    return _paymentFormView;
}

// MARK: - WALPaymentForm Delegation
- (void)paymentViewDidChangeContentSize:(CGSize)size {

//    CGFloat height = size.height;// + self.topLayoutGuide.length;
    if ([self isNewContentSize:size]) {
        CGSize resized = [self contentSizeForSize:size];
        self.currentContentHeight = resized.height;
        [self.navigationView updateFrameForOffset:size.height];
        self.paymentFormView.frame = [self expandedContentFrameForContentSize:size];
        self.paymentFormView.scrollingEnabled = NO;
        self.scrollView.contentSize = [self contentSizeForSize:size];
    }
}

- (CGRect)expandedContentFrameForContentSize:(CGSize)size {
    return CGRectMake(self.paymentFormView.frame.origin.x, self.paymentFormView.frame.origin.y,
                      self.scrollView.bounds.size.width, size.height);
}

- (CGRect)reducedContentFrameForFrame:(CGRect)rect {
    CGFloat top = self.topLayoutGuide.length + self.bottomLayoutGuide.length;
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - [self.navigationView currentNavigationalHeight] - top);
}

- (CGFloat)reducedHeightForContent {
    CGFloat top = self.topLayoutGuide.length + self.bottomLayoutGuide.length;
    return self.view.bounds.size.height - [self.navigationView currentNavigationalHeight] - top;
}

- (CGSize)contentSizeForSize:(CGSize)size {
    return CGSizeMake(size.width, size.height + self.navigationView.currentNavigationalHeight);
}


- (BOOL)isNewContentSize:(CGSize)size {
        BOOL original = [self contentSizeForSize:size].height == self.currentContentHeight;
        BOOL equal = size.height == self.currentContentHeight;
        BOOL isNew = !original && !equal;
        return isNew;
    return YES;
}

-(void)paymentViewRequestsExpand {
    // when external
    self.scrollView.contentSize = self.view.bounds.size;
    self.scrollView.scrollEnabled = NO;
    self.paymentFormView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationView updateFrameForOffset:[self reducedHeightForContent]];
    
    self.paymentFormView.frame = [self reducedContentFrameForFrame:self.view.bounds];
    self.paymentFormView.scrollingEnabled = YES;
}


- (void)paymentViewRequestsReset {
    // when internal again
    self.paymentFormView.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)viewDidStartLoading:(UIView *)viewController {
    self.navigationView.hidden = YES;
    [self.delegate viewDidStartLoading:viewController]; 
}

- (void)viewDidFinishLoading:(UIView *)viewController {
    self.navigationView.hidden = NO;
    [self.delegate viewDidFinishLoading:viewController];
}

- (void)paymentViewReady:(BOOL)userInteractionNeeded {
    if (!userInteractionNeeded) {
        [self submitTapped];
    }
    [self.delegate paymentViewReady:userInteractionNeeded];
}

- (void)paymentViewDidValidateSuccessful {
    [self.delegate paymentViewDidValidateSuccessful];
}

- (void)paymentViewDidFailValidationWithErrors:(NSArray<NSError *> *)errors {
    self.navigationView.hidden = NO;
//    self.submitButton.hidden = NO;
    self.navigationView.hidesSubmitButton = NO;
    [self.delegate paymentViewDidFailValidationWithErrors:errors];
}
- (void)paymentViewDidEncounterError:(NSError *)error {
    self.navigationView.hidden = NO;
    [self.delegate paymentViewDidEncounterError:error];
}

- (void)paymentViewAwaitsFinalState {
    [self.delegate paymentViewAwaitsFinalState];
}

- (void)paymentViewDidSucceed {
    [self.delegate paymentViewDidSucceed];
}

- (void)paymentViewDidFail {
    self.navigationView.hidden = NO;
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

// MARK: - Navigation Delegate
- (void)backTapped {
    [self.delegate paymentViewDidRequestChangePaymentMethod];
}

- (void)submitTapped {
    self.navigationView.hidden = YES;
    //    self.submitButton.hidden = YES;
    self.navigationView.hidesSubmitButton = YES;
    [self.paymentFormView validate];
}

// MARK: - Rotation
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         if (!self.scrollView.scrollEnabled) {
             [self paymentViewRequestsExpand];
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         self.scrollView.contentSize = CGSizeMake(self.navigationView.frame.size.width, self.scrollView.contentSize.height);

     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}
@end
