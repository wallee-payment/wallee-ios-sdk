//
//  WALTokenSelectionStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"

@class WALTokenVersion;

@interface WALTokenSelectionStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>
//#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)statetWithTokens:(NSArray<WALTokenVersion *> *)tokens;
NS_ASSUME_NONNULL_END
@end
