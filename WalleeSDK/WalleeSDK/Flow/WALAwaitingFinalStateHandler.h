//
//  WALAwaitingFinalStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"

@interface WALAwaitingFinalStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>

@end
