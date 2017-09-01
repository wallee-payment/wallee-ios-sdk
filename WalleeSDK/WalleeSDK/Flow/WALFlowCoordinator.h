//
//  WALFlowCoordinator.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowConfiguration;
@protocol WALPaymentFlowContainer;

@interface WALFlowCoordinator : NSObject
#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) WALFlowConfiguration *configuration;
@property (nonatomic, strong, readonly) id<WALPaymentFlowContainer> paymentContainer;

+ (id<WALPaymentFlowContainer>)startPaymentWithConfiguration:(WALFlowConfiguration *)configuration;
NS_ASSUME_NONNULL_END
@end
