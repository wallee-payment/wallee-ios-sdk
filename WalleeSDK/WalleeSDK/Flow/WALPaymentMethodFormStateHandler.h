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
@class WALPaymentMethodConfiguration;

@interface WALPaymentMethodFormStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>
//#include "WALStaticInit.h"
+ (instancetype)stateWithPaymentMethodId:(NSUInteger)paymentMethodId;
@end
