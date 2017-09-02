//
//  WALFlowCoordinator+StateDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowCoordinator+Private.h"
#import "WALFlowStateDelegate.h"

@interface WALFlowCoordinator (StateDelegate) <WALFlowStateDelegate>
@property (nonatomic, readonly) WALFlowState state;
@end

