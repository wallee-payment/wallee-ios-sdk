//
//  WALSimpleFlowStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateDelegate.h"

@class WALFlowConfiguration, WALFlowCoordinator;

@interface WALSimpleFlowStateHandler : NSObject
NS_ASSUME_NONNULL_BEGIN
- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator;
NS_ASSUME_NONNULL_END
@end
