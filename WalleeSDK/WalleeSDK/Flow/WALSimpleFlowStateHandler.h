//
//  WALSimpleFlowStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"

@class WALFlowConfiguration, WALFlowCoordinator;

@interface WALSimpleFlowStateHandler : NSObject<WALLifeCycleObject>
NS_ASSUME_NONNULL_BEGIN
- (instancetype _Nullable)init NS_UNAVAILABLE;
+ (instancetype _Nullable)new __attribute__((unavailable("Dont initialize this type directly, use the parameterized initializer")));

- (BOOL)isValid;
- (void)invalidate;

/**
 Checks if this state is stil valid/alive and propagates to the error listener

 @param coordinator will use the coordinator to propagate the error
 @return @c YES if alive @c NO otherwise
 */
+ (BOOL)isStateValid:(id<WALLifeCycleObject>)state WithCoordinator:(WALFlowCoordinator *)coordinator;
- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator;
NS_ASSUME_NONNULL_END
@end
