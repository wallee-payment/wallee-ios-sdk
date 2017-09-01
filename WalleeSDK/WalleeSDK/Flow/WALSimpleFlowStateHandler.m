//
//  WALSimpleFlowStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSimpleFlowStateHandler.h"
#import "WALFlowCoordinator.h"

@implementation WALSimpleFlowStateHandler

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    NSAssert(coordinator != nil, @"WALFlowCoordinator cannot be nil");
    NSAssert(coordinator.configuration != nil, @"WALFlowCoordinator.configuration cannot be nil");
}

@end
