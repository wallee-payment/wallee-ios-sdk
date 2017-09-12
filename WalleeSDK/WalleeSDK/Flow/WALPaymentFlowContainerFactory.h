//
//  WALFlowViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WALPaymentFlowContainer;


/**
 a block which checks the WALFlowCoordinator current handler to see if the back aciont is valid
 and if it is triggers it on that state

 @return @YES if back operation was executed @c NO otherwise
 */
typedef BOOL(^WALContainerBackAction)(void);

/**
 Implementing and supplying a dedicated WALPaymentFlowContainerFactory allows you to use your 
 cusomt flow container to achieve customized ui behaviour.
 */
@protocol WALPaymentFlowContainerFactory <NSObject>

/**
 Must Return a @c WALPaymentFlowContainer.
 <p>Since states go stale and cannot be reused it is not possible to payment_list_get_token to previous UIViewControllers.
 Instead Navigation has to always go thru the @c [WALFlowCoordinator @c triggerAction:]. the @c onBackAction
 is a convenient way to achieve this from Navigation Items (like the @c UINavigationBar Back Button)</p>
 
 the WALContainerBackAction does return @c YES if the Back Action is supported in the current state @c NO if it
 is not supported

 @param onBackAction call this block if you want to navigate back
 @return a fully instanciated WALPaymentFlowContainer
 */
- (id<WALPaymentFlowContainer> _Nonnull)buildWithBackAction:(WALContainerBackAction _Nonnull)onBackAction;
@end
