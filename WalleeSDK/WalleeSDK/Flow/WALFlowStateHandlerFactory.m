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
#import "WALSuccessHandler.h"

@implementation WALFlowStateHandlerFactory
+ (id<WALFlowStateHandler>)handlerFromState:(WALFlowState)state stateParameters:(NSDictionary * _Nullable)parameters {
    id<WALFlowStateHandler> handler;
    if (state == WALFlowStateTokenLoading) {
        handler = [[WALTokenLoadingStateHandler alloc] init];
    } else if (state == WALFlowStateTokenSelection) {
        handler = [WALTokenSelectionStateHandler statetWithTokens:parameters[WALFlowTokensParameter]];
    } else if (state == WALFlowStateSuccess) {
        handler = [WALSuccessHandler stateWithTransaction:parameters[WALFlowTransactionParameter]];
    }
    return handler;
}
@end
