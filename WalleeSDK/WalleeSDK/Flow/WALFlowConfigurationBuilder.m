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
#import "WALDefaultTokenListViewControllerFactory.h"
#import "WALDefaultSuccessViewControllerFactory.h"

@implementation WALFlowConfigurationBuilder

- (instancetype)init {
    if (self = [super init]) {
        _paymentFlowContainerFactory = [[WALDefaultPaymentFlowContainerFactory alloc] init];
        //        _paymentFormViewControllerFactory = [[DefaultPaymentFormViewControllerFactory alloc] init];
        _tokenListViewControllerFactory = [[WALDefaultTokenListViewControllerFactory alloc] init];
        //        _paymentMethodListViewControllerFactory = [[DefaultPaymentMethodListViewControllerFactory alloc] init];
        _successViewControllerFactory = [[WALDefaultSuccessViewControllerFactory alloc] init];
        //        _failureViewControllerFactory = [[DefaultFailureViewControllerFactory alloc] init];
        //        _awaitingFinalStateViewControllerFactory = [[DefaultAwaitingFinalStateViewControllerFactory alloc] init];
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
                  [WALErrorHelper checkNotEmpty:self.paymentFlowContainerFactory withMessage:@"The paymentFlowContainerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.paymentFormViewControllerFactory withMessage:@"The paymentFormViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.tokenListViewControllerFactory withMessage:@"The tokenListViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.paymentMethodListViewControllerFactory withMessage:@"The paymentMethodListViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.successViewControllerFactory withMessage:@"The successViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.iconCache withMessage:@"The successViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.listeners withMessage:@"The listeners list is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.failureViewControllerFactory withMessage:@"The failureViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.awaitingFinalStateViewControllerFactory withMessage:@"The awaitingFinalStateViewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.iconRequestManager withMessage:@"The iconRequestManager is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.webServiceApiClient withMessage:@"The webServiceApiClient is required." error:error]);
    return valid;
}

@end
