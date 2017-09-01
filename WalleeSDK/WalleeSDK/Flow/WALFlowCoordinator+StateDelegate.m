//
//  WALFlowCoordinator+StateDelegate.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFlowCoordinator+StateDelegate.h"

@implementation WALFlowCoordinator (StateDelegate)

- (void)changeStateTo:(WALFlowState)targetState {
    
}

- (void)waiting {
    NSLog(@"WAITING...");
}

- (void)ready {
    NSLog(@"READY!");
    
}

@end
