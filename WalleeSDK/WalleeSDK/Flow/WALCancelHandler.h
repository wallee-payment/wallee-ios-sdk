//
//  WALCancelHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"
@class WALTransaction;

@interface WALCancelHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)stateWithTransaction:(WALTransaction  *)transaction;
NS_ASSUME_NONNULL_END
@end
