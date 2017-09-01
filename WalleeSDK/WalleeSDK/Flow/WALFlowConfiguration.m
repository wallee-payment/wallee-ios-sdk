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

/**
 @warning
 do not use this initializer directly as it does not validate its correct state. 
 use the provided static intitializers

 @param builder builder to use
 @return initialized WALFlowConfiguration
 */
- (instancetype)initWithBuilder:(WALFlowConfigurationBuilder *)builder;
@end

@implementation WALFlowConfiguration

- (instancetype)initWithBuilder:(WALFlowConfigurationBuilder *)builder {
    if (self = [super init]) {
        _paymentFlowContainerFactory = builder.paymentFlowContainerFactory;
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

+ (instancetype)makeWithBlock:(void (^ _Nullable)(WALFlowConfigurationBuilder * _Nonnull))buildBlock error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    WALFlowConfigurationBuilder *builder = [[WALFlowConfigurationBuilder alloc] init];
    if (buildBlock) {
        buildBlock(builder);
    }
    return [self.class makeWithBuilder:builder error:error];
}

+ (instancetype)makeWithBuilder:(WALFlowConfigurationBuilder *)builder error:(NSError **)error {
    if (![builder valid:error]) {
        return nil;
    }
    
    WALFlowConfiguration *config = [[self alloc] initWithBuilder:builder];
    return config;
}

@end
