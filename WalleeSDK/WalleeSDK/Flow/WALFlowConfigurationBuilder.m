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
#import "WALDefaultViewControllerFactory.h"
#import "WALCredentialsProvider.h"

@implementation WALFlowConfigurationBuilder

- (instancetype)init {
    if (self = [super init]) {
        _paymentFlowContainerFactory = [[WALDefaultPaymentFlowContainerFactory alloc] init];
        _viewControllerFactory = [[WALDefaultViewControllerFactory alloc] init];
    }
    
    return self;
}

- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher {
    if (self = [self init]) {
        
//        _iconCache = [[WALInMemoryCach alloc] init];
//        _iconRequestManager = [[WALNSURLIconRequestManager alloc] init];
        WALCredentialsProvider *provider = [[WALCredentialsProvider alloc] initWith:credentialsFetcher];
        _webServiceApiClient = [WALNSURLSessionApiClient clientWithCredentialsProvider:provider];
    }
    
    return self;
}

- (BOOL)valid:(NSError *__autoreleasing  _Nullable *)error {
    BOOL valid = (                  
                  [WALErrorHelper checkNotEmpty:self.paymentFlowContainerFactory withMessage:@"The paymentFlowContainerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.viewControllerFactory withMessage:@"The viewControllerFactory is required." error:error]// &&
//                  [WALErrorHelper checkNotEmpty:self.iconCache withMessage:@"The iconCache is required." error:error] &&
//                  [WALErrorHelper checkNotEmpty:self.listeners withMessage:@"The listeners list is required." error:error] &&
//                  [WALErrorHelper checkNotEmpty:self.iconRequestManager withMessage:@"The iconRequestManager is required." error:error] &&
//                  [WALErrorHelper checkNotEmpty:self.webServiceApiClient withMessage:@"The webServiceApiClient is required." error:error]
                  );
    return valid;
}

@end
