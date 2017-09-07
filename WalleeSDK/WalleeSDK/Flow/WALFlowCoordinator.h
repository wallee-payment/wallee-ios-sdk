//
//  WALFlowCoordinator.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowTypes.h"

@class WALFlowConfiguration;
@protocol WALPaymentFlowContainer;

@interface WALFlowCoordinator : NSObject
//#include "WALStaticInit.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) WALFlowConfiguration *configuration;
@property (nonatomic, strong, readonly) id<WALPaymentFlowContainer> paymentContainer;

+ (instancetype)paymentFlowWithConfiguration:(WALFlowConfiguration *)configuration;
- (void)start;

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
- (BOOL)triggerAction:(WALFlowAction)flowAction;
NS_ASSUME_NONNULL_END
@end
