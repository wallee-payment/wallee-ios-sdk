//
//  WALFlowStateHandlerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowStateHandlerFactory.h"
#import "WALFlowTypes.h"

#import "WALTokenLoadingStateHandler.h"
#import "WALTokenSelectionStateHandler.h"

#import "WALPaymentMethodLoadingStateHandler.h"
#import "WALPaymentMethodSelectionStateHandler.h"
#import "WALPaymentMethodFormStateHandler.h"

#import "WALAwaitingFinalStateHandler.h"
#import "WALSuccessHandler.h"
#import "WALFailureHandler.h"

@implementation WALFlowStateHandlerFactory
+ (id<WALFlowStateHandler>)handlerFromState:(WALFlowState)state stateParameters:(NSDictionary * _Nullable)parameters {
    
    switch (state) {
        case WALFlowStateTokenLoading:
            return [[WALTokenLoadingStateHandler alloc] init];
            break;
        case WALFlowStateTokenSelection:
            return [WALTokenSelectionStateHandler statetWithTokens:parameters[WALFlowTokensParameter]];
            break;
        case WALFlowStatePaymentMethodLoading:
            return [[WALPaymentMethodLoadingStateHandler alloc] init];
            break;
        case WALFlowStatePaymentMethodSelection:
            return [WALPaymentMethodSelectionStateHandler stateWithPaymentMethods:parameters[WALFlowPaymentMethodsParameter]];
            break;
        case WALFlowStatePaymentForm:
            return [WALPaymentMethodFormStateHandler stateWithPaymentMethod:parameters[WALFlowPaymentMethodsParameter]];
            break;
        case WALFlowStateAwaitingFinalState:
            return [[WALAwaitingFinalStateHandler alloc] init];
            break;
        case WALFlowStateSuccess:
            return [WALSuccessHandler stateWithTransaction:parameters[WALFlowTransactionParameter]];
            break;
        case WALFlowStateFailure:
            return [WALSuccessHandler stateWithTransaction:parameters[WALFlowTransactionParameter]];
            break;
        default:
            return nil;
            break;
    }
    
//    id<WALFlowStateHandler> handler;
//    if (state == WALFlowStateTokenLoading) {
//        handler = [[WALTokenLoadingStateHandler alloc] init];
//    } else if (state == WALFlowStateTokenSelection) {
//        handler = [WALTokenSelectionStateHandler statetWithTokens:parameters[WALFlowTokensParameter]];
//    } else if (state == WALFlowStateSuccess) {
//        handler = [WALSuccessHandler stateWithTransaction:parameters[WALFlowTransactionParameter]];
//    } else if (state == WALFlowStateFailure) {
//        handler = [WALSuccessHandler stateWithTransaction:parameters[WALFlowTransactionParameter]];
//    }
//    return handler;
}
@end
