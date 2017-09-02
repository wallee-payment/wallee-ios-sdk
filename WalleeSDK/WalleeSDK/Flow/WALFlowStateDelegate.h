//
//  WALFlowStateDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 30.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowTypes.h"

/*!
 The coordinator callback allows to trigger certain operations on the coordinator.
 *
 <p>This is the way the FlowStateHandler communicates with the {@link
 FlowCoordinator}.</p>
 *
 <p>This interface is intentionally package protected to prevent using it by other classes to
 trigger something.</p>
 */
@protocol WALFlowStateDelegate <NSObject>

    /**
     This triggers a state change to the  @c targetState. The  @c argument is passed along
     to the new state.
     *
     @param targetState the state to which the coordinator should switch to.
     @param argument    the argument which is passed to the new FlowStateHandler.
     */
- (void)changeStateTo:(WALFlowState) targetState;
    
    /**
     To indicate that the view provided to the FlowCoordinator can be shown.
     */
- (void)ready;
    
    /**
     By calling this method the FlowCoordinator will show the waiting view.
     */
- (void)waiting;
@end
