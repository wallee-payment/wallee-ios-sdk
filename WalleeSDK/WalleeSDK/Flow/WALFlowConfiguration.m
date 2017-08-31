//
//  WALFlowConfiguration.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowConfiguration.h"
#import "WALFlowConfigurationBuilder.h"

@interface WALFlowConfiguration ()
- (instancetype)initWithBuilder:(WALFlowConfigurationBuilder *)builder;
@end

@implementation WALFlowConfiguration

- (instancetype)initWithBuilder:(WALFlowConfigurationBuilder *)builder {
    if (self = [super init]) {
        _paymentFormViewFactory = builder.paymentFormViewFactory;
        _tokenListViewFactory = builder.tokenListViewFactory;
        _paymentMethodListViewFactory = builder.paymentMethodListViewFactory;
        _successViewFactory = builder.successViewFactory;
        _awaitingFinalStateViewFactory = builder.awaitingFinalStateViewFactory;
        _iconCache = builder.iconCache;
        _iconRequestManager = builder.iconRequestManager;
        _webServiceApiClient = builder.webServiceApiClient;
    }
    return self;
}

+ (instancetype)makeWithBuilder:(void (^)(WALFlowConfigurationBuilder * _Nonnull))buildBlock error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    WALFlowConfigurationBuilder *builder = [[WALFlowConfigurationBuilder alloc] init];
    buildBlock(builder);

    if (![builder valid:error]) {
        return nil;
    }
    
    WALFlowConfiguration *config = [[self alloc] initWithBuilder:builder];
    return config;
}

@end
