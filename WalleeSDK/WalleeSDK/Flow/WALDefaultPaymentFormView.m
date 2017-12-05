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
#import "WALMobileSdkUrl.h"


@interface WALDefaultPaymentFormView ()

@property (nonatomic, copy) WALMobileSdkUrl *mobileSdkUrl;
@property (nonatomic) NSUInteger paymentMethodId;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, readwrite) BOOL isSubmitted;

@property (nonatomic, readwrite) CGSize contentSize;

/**
 the reported height of the content via javascript
 */
@property (nonatomic) CGFloat currentWebContentHeight;

/**
 the current height reported by the @c scrollview.contentSize
 */
@property (nonatomic) CGFloat currentContentHeight;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@property (nonatomic) BOOL isFirstRequest;
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
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollingEnabled = YES;
        [self addSubview:self.webView];
        self.isFirstRequest = YES;

    }
    return self;
}

- (void)removeFromSuperview {
    [self.timeoutTimer invalidate];
    [super removeFromSuperview];
}

- (void)addAJAXController:(WKUserContentController *)controller {
    NSString *jsHandler = [self inlineScript];
    
    WKUserScript *ajaxHandler = [[WKUserScript alloc]initWithSource:jsHandler injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [controller addScriptMessageHandler:self name:@"callbackHandler"];
    [controller addUserScript:ajaxHandler];
}

- (void)loadPaymentView:(WALMobileSdkUrl *)mobileSdkUrl forPaymentMethodId:(NSUInteger)paymentMethodId {
    self.isLoading = YES;
    [self.delegate viewDidStartLoading:self];
    
    self.paymentMethodId = paymentMethodId;
    self.mobileSdkUrl = mobileSdkUrl;
    
    NSError *error;
    NSURL *url = [self.mobileSdkUrl buildPaymentMethodUrl:self.paymentMethodId error:&error];
    if (!url) {
        [self.delegate paymentViewDidEncounterError:error];
        return;
    }
    self.webView.frame = CGRectMake(0, 0, 0, 0);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.isLoading = NO;
    
    if (self.isFirstRequest) {
        self.isFirstRequest = NO;
        self.webView.frame = self.frame;
        [self scheduleTimer];
        [self performSelector:@selector(evaluatePaymentFormReady) withObject:nil afterDelay:0.1f];
    }

    [self.delegate viewDidFinishLoading:self];
}


- (void)setScrollingEnabled:(BOOL)scrollingEnabled {
    _scrollingEnabled = scrollingEnabled;
    self.webView.scrollView.scrollEnabled = _scrollingEnabled;
}

// MARK: - Timer
- (void)scheduleTimer {
    [self.timeoutTimer invalidate];
    NSDate *expire = [NSDate dateWithTimeIntervalSince1970:self.mobileSdkUrl.expiryDate];
    NSTimeInterval interval = expire.timeIntervalSinceNow;
    
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerTick) userInfo:nil repeats:NO];
    
}

- (void)cancelTimer {
    [self.timeoutTimer invalidate];
}

- (void)timerTick {
    [self.delegate viewControllerDidExpire:nil];
}

// MARK: - AJAX Handling
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"Did Receive JS Message: %@ %@", message, message.body);
    NSString *url = message.body;
    __weak WALDefaultPaymentFormView *weakSelf = self;
    [WALPaymentFormAJAXParser parseUrlString:url
                                 resultBlock:^(WALPaymentFormAJAXOperationType resultType, id  _Nullable result) {
                                     WALDefaultPaymentFormView *strongSelf = weakSelf;
                                     [strongSelf handleAJAXOperation:resultType withResult:result forDelegate:strongSelf.delegate];
                                 }];
}

///Connection to Localhost is handled in case of redirects etc.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    __weak WALDefaultPaymentFormView *weakSelf = self;
    NSString *urlString = navigationAction.request.URL.absoluteString;
    BOOL isCallback = [WALPaymentFormAJAXParser parseUrlString:urlString
                                                   resultBlock:^(WALPaymentFormAJAXOperationType resultType, id  _Nullable result) {
        WALDefaultPaymentFormView *strongSelf = weakSelf;
        [strongSelf handleAJAXOperation:resultType withResult:result forDelegate:strongSelf.delegate];
    }];
    BOOL isInitialUrl = [self isInitialUrl:urlString];
    if (!isCallback && !isInitialUrl) {
        NSLog(@" -- we are forwarded to a new page and as such request more space");
        [self.delegate paymentViewRequestsExpand];
    }
    decisionHandler(isCallback ? WKNavigationActionPolicyCancel : WKNavigationActionPolicyAllow);
}

- (void)handleAJAXOperation:(WALPaymentFormAJAXOperationType)operation withResult:(id _Nullable)result forDelegate:(id<WALPaymentFormDelegate> _Nullable)delegate {
    if (!delegate) {
        return;
    }
    CGFloat floatResult = 0;
    if ([result respondsToSelector:@selector(floatValue)]) {
        floatResult = [((NSNumber*)result) floatValue];
    }

    switch (operation) {
        case WALPaymentFormAJAXOperationTypeSuccess:
            [delegate paymentViewDidSucceed];
            break;
        case WALPaymentFormAJAXOperationTypeFailure:
            [delegate paymentViewDidFail];
            break;
        case WALPaymentFormAJAXOperationTypeAwaitingFinalStatus:
            [delegate paymentViewAwaitsFinalState];
            break;
        case WALPaymentFormAJAXOperationTypeValidationSuccess:
            [delegate paymentViewDidValidateSuccessful];
            break;
        case WALPaymentFormAJAXOperationTypeValidationFailure:
            [delegate paymentViewDidFailValidationWithErrors:result];
            break;
        case WALPaymentFormAJAXOperationTypeError:
            [delegate paymentViewDidEncounterError:result];
            break;
        case WALPaymentFormAJAXOperationTypeEnlargeView:
            [self.timeoutTimer invalidate];
            [delegate paymentViewRequestsExpand];
            break;
        case WALPaymentFormAJAXOperationTypeHeightChange:
            self.currentWebContentHeight = floatResult;
            [delegate paymentViewDidChangeContentSize:CGSizeMake(self.frame.size.width, floatResult + self.webView.scrollView.contentInset.top)];
            break;
        case WALPaymentFormAJAXOperationTypeInitialize:
        case WALPaymentFormAJAXOperationTypeUnknown:
            // fall thru
        default:
            break;
    }
}

- (BOOL)isInitialUrl:(NSString *)urlString {
    NSString *compareString = [self.mobileSdkUrl buildPaymentMethodUrl:self.paymentMethodId error:nil].absoluteString;
    return [urlString isEqualToString:compareString];
}

// MARK: - Commands
- (void)checkValidationCommandExistance:(void (^)(BOOL))completion {
    [self.webView evaluateJavaScript:@"javascript:(function () { if (typeof MobileSdkHandler.validate === \"function\") { return true; } else { console.log(' validate Command does not exist'); return false; } })()"
                   completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                       BOOL canValidateForm =  (!error && object && [object boolValue]);
                       completion(canValidateForm);
                   }];
}

- (void)validate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendValidationCommand];
    });
}

- (void)sendValidationCommand {
    [self.webView evaluateJavaScript:@"javascript:(function () { MobileSdkHandler.validate(); })()"
                   completionHandler:^(id _Nullable object, NSError * _Nullable error) {
                       if (error) {
                           NSLog(@"js evaluate object %@ error %@", object, error);
                           [self.delegate paymentViewDidEncounterError:error];
                       }
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
                       if (error) {
                           NSLog(@"js evaluate object %@ error %@", object, error);
                           [self.delegate paymentViewDidEncounterError:error];
                       }
                   }];
}

// MARK: - Resizing

- (void)evaluatePaymentFormReady {
    [self getWebViewHeight:^(CGFloat height) {
        [self.delegate paymentViewReady:(height > 0.0)];
    }];
}

- (void)getWebViewHeight:(void(^)(CGFloat))onHeightEvaluated {
    [self.webView evaluateJavaScript: @"document.body.scrollHeight" completionHandler: ^(id response, NSError *error) {
        onHeightEvaluated([response floatValue]);
    }];
}

- (NSString *)inlineScript {
    return @"$( document ).ajaxSend(function( event, request, settings )  {"
    @"    callNativeApp (settings.url);"
    @"});"
    
    @"function callNativeApp (data) {"
    @"    try {"
    @"        webkit.messageHandlers.callbackHandler.postMessage(data);"
    @"    }"
    @"    catch(err) {"
    @"        console.log('The native context does not exist yet');"
    @"    }"
    @"}";
    
}

@end
