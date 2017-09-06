//
//  WALDefaultPaymentFormView.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentFormView.h"
#import <WebKit/WebKit.h>
#import "WALPaymentFormDelegate.h"
#import "WALPaymentFormAJAXParser.h"

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
        
        [self addAJAXController:controller];
        configuration.userContentController = controller;
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        self.webView.navigationDelegate = self;
        
        self.scrollingEnabled = YES;
        //    self.webView.scrollView.scrollEnabled = NO;
        [self addSubview:self.webView];
        
    }
    return self;
}

- (void)addAJAXController:(WKUserContentController *)controller {
    NSString *jsHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"ajax" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *ajaxHandler = [[WKUserScript alloc]initWithSource:jsHandler injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [controller addScriptMessageHandler:self name:@"callbackHandler"];
    [controller addUserScript:ajaxHandler];
}

- (void)loadPaymentView:(NSURL *)mobileSdkUrl {
    self.isLoading = YES;
    [self.delegate viewDidStartLoading:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:mobileSdkUrl]];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: didFinishNavigation: %@", navigation);
    self.isLoading = NO;
    [self.delegate viewDidFinishLoading:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
}

// MARK: - AJAX Handling
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"Did REceive Message: %@ %@", message, message.body);
    NSString *url = message.body;
    __weak WALDefaultPaymentFormView *weakSelf = self;
    [WALPaymentFormAJAXParser parseUrlString:url resultBlock:^(WALPaymentFormAJAXOperationType resultType, id  _Nullable result) {
        WALDefaultPaymentFormView *strongSelf = weakSelf;
        [strongSelf handleAJAXOperation:resultType withResult:result forDelegate:strongSelf.delegate];
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView: FAIL PROVISIONAL: %@ ERROR: %@", navigation, error);
}

- (void)handleAJAXOperation:(WALPaymentFormAJAXOperationType)operation withResult:(id _Nullable)result forDelegate:(id<WALPaymentFormDelegate> _Nullable)delegate {
    if (!delegate) {
        return;
    }
    switch (operation) {
        case WALPaymentFormAJAXOperationTypeSuccess:
            [delegate paymentViewDidSucceed:nil];
            break;
        case WALPaymentFormAJAXOperationTypeFailure:
            [delegate paymentViewDidFail:nil];
            break;
        case WALPaymentFormAJAXOperationTypeAwaitingFinalStatus:
            [delegate paymentViewAwaitsFinalState:nil];
            break;
        case WALPaymentFormAJAXOperationTypeValidationSuccess:
            [delegate paymentViewDidValidateSuccessful:nil];
            break;
        case WALPaymentFormAJAXOperationTypeValidationFailure:
            [delegate paymentView:nil didFailValidationWithErrors:result];
            break;
        case WALPaymentFormAJAXOperationTypeError:
            [delegate paymentView:nil didEncounterError:result];
            break;
        case WALPaymentFormAJAXOperationTypeEnlargeView:
        case WALPaymentFormAJAXOperationTypeHeightChange:
        case WALPaymentFormAJAXOperationTypeInitialize:
        case WALPaymentFormAJAXOperationTypeUnknown:
            // fall thru
        default:
            break;
    }

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
        [self sendSubmitCommand];
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



// MARK: - WKWebView Delegation
///Connection to Localhost is handled in case of redirects etc.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"webView:  decidePolicyFor Action: %@ ", navigationAction.request);
    
    __weak WALDefaultPaymentFormView *weakSelf = self;
    BOOL isCallback = [WALPaymentFormAJAXParser parseUrlString:navigationAction.request.URL.absoluteString resultBlock:^(WALPaymentFormAJAXOperationType resultType, id  _Nullable result) {
        WALDefaultPaymentFormView *strongSelf = weakSelf;
        [strongSelf handleAJAXOperation:resultType withResult:result forDelegate:strongSelf.delegate];
    }];
    
    decisionHandler(isCallback ? WKNavigationActionPolicyCancel : WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"webView:  decidePolicyFor RESPONSE: %@ ", navigationResponse);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: didStart: %@" , navigation);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView: FAIL: %@ ERROR: %@", navigation, error);
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"Webcontent process didterminate");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: didCommit: %@", navigation);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSLog(@"Did receive auth challenge");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView: REDIRECT: %@", navigation);
}

@end
