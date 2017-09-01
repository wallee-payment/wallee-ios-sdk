//
//  WALFlowConfigurationBuilder.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowConfigurationBuilder.h"
#import "WALErrorDomain.h"
#import "WALNSURLSessionApiClient.h"
#import "WALDefaultPaymentFlowContainerFactory.h"

@implementation WALFlowConfigurationBuilder

- (instancetype)init {
    if (self = [super init]) {
        _paymentFlowContainerFactory = [[WALDefaultPaymentFlowContainerFactory alloc] init];
        //        _paymentFormViewFactory = [[DefaultPaymentFormViewFactory alloc] init];
        //        _tokenListViewFactory = [[DefaultTokenListViewFactory alloc] init];
        //        _paymentMethodListViewFactory = [[DefaultPaymentMethodListViewFactory alloc] init];
        //        _successViewFactory = [[DefaultSuccessViewFactory alloc] init];
        //        _failureViewFactory = [[DefaultFailureViewFactory alloc] init];
        //        _awaitingFinalStateViewFactory = [[DefaultAwaitingFinalStateViewFactory alloc] init];
        _listeners = @[];
    }
    
    return self;
}

- (instancetype)initWithCredentialsProvider:(WALCredentialsProvider *)credentialsProvider {
    if (self = [self init]) {
        
//        _iconCache = [[WALInMemoryCach alloc] init];
//        _iconRequestManager = [[WALNSURLIconRequestManager alloc] init];
        _webServiceApiClient = [WALNSURLSessionApiClient clientWithCredentialsProvider:credentialsProvider];
    }
    
    return self;
}

- (BOOL)valid:(NSError *__autoreleasing  _Nullable *)error {
    BOOL valid = (                  
                  [WALErrorHelper checkEmpty:self.paymentFlowContainerFactory withMessage:@"The paymentFlowContainerFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.paymentFormViewFactory withMessage:@"The paymentFormViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.tokenListViewFactory withMessage:@"The tokenListViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.paymentMethodListViewFactory withMessage:@"The paymentMethodListViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.successViewFactory withMessage:@"The successViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.iconCache withMessage:@"The successViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.listeners withMessage:@"The listeners list is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.failureViewFactory withMessage:@"The failureViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.awaitingFinalStateViewFactory withMessage:@"The awaitingFinalStateViewFactory is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.iconRequestManager withMessage:@"The iconRequestManager is required." error:error] &&
                  [WALErrorHelper checkEmpty:self.webServiceApiClient withMessage:@"The webServiceApiClient is required." error:error]);
    return valid;
}

@end
