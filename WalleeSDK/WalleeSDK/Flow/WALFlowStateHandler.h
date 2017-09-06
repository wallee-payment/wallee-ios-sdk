//
//  WALFlowStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 30.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALFlowTypes.h"
@class WALFlowCoordinator;
@protocol WALLifeCycleObject;

/**
 The state handler represents a handler for FlowState. Each state has at least one
 handler. The handler is responsible for triggering the state transitions and for managing the
 underlying views.
 */
@protocol WALFlowStateHandler <NSObject, WALLifeCycleObject>
NS_ASSUME_NONNULL_BEGIN
/**
 This method is invoked when the state handler can initialize the state and as such eventually
 trigger a state change.
 
 <p>This method indicates to the flow state handler when the coordinator is onTokenSelectionViewReady to accept
 state changes and view changes.</p>
 */
- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator;

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator;

/**
 This method is called to test if a particular @c action can be executed with this
 handler.
 
 <p>The handler should return @c NO when it does not support the action. Otherwise it
 should return @c YES.</p>
 
 @param flowAction the action which should be checked.
 @return @c YES when the handler supports the action in the current situation. Otherwise
 the method should return @c NO.
 */
- (BOOL)dryTriggerAction:(WALFlowAction)flowAction;

/**
 This method is called to actually trigger the @c flowAction.
 
 <p>The method can return @c NO when the execution is not possible resp. the current
 situation does not allow it. The behavior should be consistent to WALFLowStateHandler::dryTriggerAction
 </p>

 @param flowAction the action which should be executed.
 @return @c YES when the action was executed. Otherwise @c NO.
 */
- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator;

/**
 Every State must be initializable with a parameter dictionary

 @param parameters input parameters for the state
 @return a @c WALFlowStateHandler or nil if the input was invalid
 */
+ (instancetype _Nullable)stateWithParameters:(NSDictionary *_Nullable)parameters;

NS_ASSUME_NONNULL_END
@end


@protocol WALLifeCycleObject <NSObject>
/**
 once the state has finished and the @c WALTransactionCoordinator has move to another state
 this @c WALStateHandler is invalid
 */
- (BOOL)isValid;


/**
 The implementing Object must invalidate itselfe upon receiving this message.
 Meaning that i cannot be used for further communication
 */
- (void)invalidate;


@end
