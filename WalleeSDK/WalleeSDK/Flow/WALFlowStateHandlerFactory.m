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
#import "WALCancelHandler.h"
#import "WALFailureHandler.h"

@implementation WALFlowStateHandlerFactory
+ (id<WALFlowStateHandler>)handlerFromState:(WALFlowState)state stateParameters:(NSDictionary * _Nullable)parameters {
    
    switch (state) {
        case WALFlowStateTokenLoading:
            return [WALTokenLoadingStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStateTokenSelection:
            return [WALTokenSelectionStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStatePaymentMethodLoading:
            return [WALPaymentMethodLoadingStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStatePaymentMethodSelection:
            return [WALPaymentMethodSelectionStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStatePaymentForm:
            return [WALPaymentMethodFormStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStateAwaitingFinalState:
            return [WALAwaitingFinalStateHandler stateWithParameters:parameters];
            break;
        case WALFlowStateSuccess:
            return [WALSuccessHandler stateWithParameters:parameters];
            break;
        case WALFlowStateCancel:
            return [WALCancelHandler stateWithParameters:parameters];
            break;
        case WALFlowStateFailure:
            return [WALFailureHandler stateWithParameters:parameters];
            break;
        default:
            return nil;
            break;
    }
}
@end
