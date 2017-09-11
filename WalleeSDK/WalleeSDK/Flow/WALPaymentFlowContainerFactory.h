//
//  WALFlowViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WALPaymentFlowContainer;

typedef BOOL(^WALContainerBackAction)(void);

@protocol WALPaymentFlowContainerFactory <NSObject>
/**
 Must Return a @c WALPaymentFlowContainer.
 Since states go stale and cannot be reused it is not possible to go back to previous UIViewControllers.
 Instead Navigation has to always go thru the @c [WALFlowCoordinator triggerAction:]. the @c onBackAction
 is a convenient way to achieve this from Navigation Items (like the @c UINavigationBar Back Button)
 
 the WALContainerBackAction does return @c YES if the Back Action is supported in the current state @c NO if it
 is not supported

 @param onBackAction call this block if you want to navigate back
 @return a fully instanciated WALPaymentFlowContainer
 */
- (id<WALPaymentFlowContainer> _Nonnull)buildWithBackAction:(WALContainerBackAction _Nonnull)onBackAction;
@end
