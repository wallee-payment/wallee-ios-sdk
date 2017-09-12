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

@interface WALPaymentMethodFormStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler, WALPaymentFormDelegate>
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)stateWithPaymentMethodId:(NSUInteger)paymentMethodId;
NS_ASSUME_NONNULL_END
@end
