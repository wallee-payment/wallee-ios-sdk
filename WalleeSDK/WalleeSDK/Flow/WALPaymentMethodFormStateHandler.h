//
//  WALPaymentMethodFormHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"
#import "WALPaymentFormDelegate.h"
@class WALPaymentMethodConfiguration;
@class WALLoadedPaymentMethods;
@class WALLoadedTokens;

@interface WALPaymentMethodFormStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler, WALPaymentFormDelegate>
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)stateWithPaymentMethodId:(NSUInteger)paymentMethodId
                       andPaymentMethods:(WALLoadedPaymentMethods *)loadedMethods
                               andTokens:(WALLoadedTokens *)loadedTokens;
NS_ASSUME_NONNULL_END
@end
