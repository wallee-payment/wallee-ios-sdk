//
//  WALFlowListener.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowCoordinator, WALApiClientError, WALApiServerError;

/**
 *
 */
@protocol WALPaymentFlowDelegate <NSObject>

- (void)flowCoordinatorWillLoadToken:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinatorDidDisplayTokenSelection:(WALFlowCoordinator *)coordinator;

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiClientError:(WALApiClientError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiServerError:(WALApiServerError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiNetworktError:(NSError*)error;
@end
