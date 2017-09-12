//
//  WALSimpleFlowStateHandler+Private.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 12.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSimpleFlowStateHandler.h"

@interface WALSimpleFlowStateHandler (Private)
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic) BOOL alive;
- (instancetype)initInternal;
NS_ASSUME_NONNULL_END
@end
