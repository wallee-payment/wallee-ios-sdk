//
//  WALDefaultPaymentFormView.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentFormView.h"
#import <WebKit/WebKit.h>

@interface WALDefaultPaymentFormView ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, readwrite) CGSize contentSize;

@property (nonatomic, readwrite) BOOL isSubmitted;
@end

@implementation WALDefaultPaymentFormView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *controller = [[WKUserContentController alloc] init];
        [controller addScriptMessageHandler:self name:@"MobileSdkHandler"];
        configuration.userContentController = controller;
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        self.webView.navigationDelegate = self;
        
        self.scrollingEnabled = YES;
        //    self.webView.scrollView.scrollEnabled = NO;
        [self addSubview:self.webView];
        
    }
    return self;
}

- (void)loadPaymentView:(NSURL *)mobileSdkUrl {
    self.isLoading = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:mobileSdkUrl]];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: %@ didFinishNavigation: %@", webView, navigation);
    self.isLoading = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

// MARK: - JS

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"Did REceive Message: %@", message);
}

// MARK: - WKWebView Delegation
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"webView: %@ decidePolicyFor Action: %@ decisionHandler: %@", webView, navigationAction, decisionHandler);
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"webView: %@ decidePolicyFor RESPONSE: %@ decisionHandler: %@", webView, navigationResponse, decisionHandler);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: %@ didStart: %@", webView, navigation);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView: %@ FAIL PROVISIONAL: %@ ERROR: %@", webView, navigation, error);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView: %@ FAIL: %@ ERROR: %@", webView, navigation, error);
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"Webcontent process didterminate");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: %@ didCommit: %@", webView, navigation);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSLog(@"Did receive auth challenge");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: %@ REDIRECT: %@", webView, navigation);
}

// MARK: - Commands
- (void)validate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendValidationCommand];
    });
}

- (void)sendValidationCommand {
    [self.webView evaluateJavaScript:@"javascript:(function () { MobileSdkHandler.validate(); })()"
                   completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                       NSLog(@"js evaluate object %@ error %@", object, error);
    }];
}

- (void)submit {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendValidationCommand];
    });
}

- (void)sendSubmitCommand {
    [self.webView evaluateJavaScript:@"javascript:(function () { MobileSdkHandler.submit(); })()"
                   completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                       NSLog(@"js evaluate object %@ error %@", object, error);
                   }];
}

// MARK: - Resizing
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    }
}

- (void)didMoveToWindow {
    if (self.window) {
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    static CGFloat contentHeight = 0.0;
    if (object == self.webView.scrollView && [keyPath isEqual:@"contentSize"]) {
        
        if (self.scrollingEnabled) {
            return;
        }
        
        UIScrollView *webScrollView = self.webView.scrollView;
        CGFloat newContentHeight = webScrollView.contentSize.height;
        CGFloat newContentWidth = webScrollView.contentSize.width;
        NSLog(@"New contentSize: %f x %f", webScrollView.contentSize.width, newContentHeight);
        if (contentHeight == newContentHeight) {
            return;
        }
        contentHeight = newContentHeight;
        //        self.webView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, newContentHeight);
        self.webView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, newContentHeight);

    }
}
@end
