//
//  WALPaymentMethodSelectionHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"
@class WALPaymentMethodConfiguration;

@interface WALPaymentMethodSelectionStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>
//#include "WALStaticInit.h"
+ (instancetype)stateWithPaymentMethods:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethods;
@end
