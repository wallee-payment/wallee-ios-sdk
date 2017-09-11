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
#import "WALNSURLIconLoader.h"
#import "WALDefaultIconCache.h"
#import "WALInMemoryIconStore.h"

#import "WALDefaultPaymentFlowContainerFactory.h"
#import "WALDefaultViewControllerFactory.h"
#import "WALCredentialsProvider.h"

@implementation WALFlowConfigurationBuilder

- (instancetype)init {
    return [super init];
}

- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher {
    return [self initWithCredentialsFetcher:credentialsFetcher operationQueue:nil];
}

- (instancetype)initWithCredentialsFetcher:(id<WALCredentialsFetcher>)credentialsFetcher operationQueue:(NSOperationQueue * _Nullable)operationQueue {
    if (self = [super init]) {
        _paymentFlowContainerFactory = [[WALDefaultPaymentFlowContainerFactory alloc] init];
        _viewControllerFactory = [[WALDefaultViewControllerFactory alloc] init];
        
        WALCredentialsProvider *provider = [[WALCredentialsProvider alloc] initWith:credentialsFetcher];
        _webServiceApiClient = [WALNSURLSessionApiClient clientWithCredentialsProvider:provider operationQueue:operationQueue];
        
        id<WALIconLoader> iconLoader = [WALNSURLIconLoader iconLoaderWithOperationQueue:operationQueue];
        id<WALIconStore> iconStore = [[WALInMemoryIconStore alloc] init];
        _iconCache = [[WALDefaultIconCache alloc] initWithIconLoader:iconLoader iconStore:iconStore];
    }
    
    return self;
}

- (BOOL)valid:(NSError *__autoreleasing  _Nullable *)error {
    BOOL valid = (                  
                  [WALErrorHelper checkNotEmpty:self.paymentFlowContainerFactory withMessage:@"The paymentFlowContainerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.viewControllerFactory withMessage:@"The viewControllerFactory is required." error:error] &&
                  [WALErrorHelper checkNotEmpty:self.iconCache withMessage:@"The iconCache is required." error:error] &&
//                  [WALErrorHelper checkNotEmpty:self.listeners withMessage:@"The listeners list is required." error:error] &&

                  [WALErrorHelper checkNotEmpty:self.webServiceApiClient withMessage:@"The webServiceApiClient is required." error:error]
                  );
    return valid;
}

@end
