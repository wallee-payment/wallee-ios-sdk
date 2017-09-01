//
//  WALFlowStateHandlerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowStateHandlerFactory.h"
#import "WALTokenLoadingStateHandler.h"


@implementation WALFlowStateHandlerFactory
+ (id<WALFlowStateHandler>)handlerFromState:(WALFlowState)state {
    id<WALFlowStateHandler> handler;
    if (state == WALFlowStateTokenLoading) {
//        handler = [WALTokenLoadingStateHandler]
    }
    return handler;
}
@end
