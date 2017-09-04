//
//  WALFlowListener.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowCoordinator, WALApiClientError, WALApiServerError, WALTokenVersion, WALTransaction;

/**
 *
 */
@protocol WALPaymentFlowDelegate <NSObject>

- (void)flowCoordinatorWillLoadToken:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinatorWillDisplayTokenSelection:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator didSelectToken:(WALTokenVersion *)token;

- (void)flowCoordinatorWillLoadPaymentMethod:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinatorWillDisplayPaymentMethodSelection:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator didSelectPaymentMethod:(WALPaymentMethodConfiguration *)paymentMethod;

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidSucceed:(WALTransaction *)transaction;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidFail:(WALTransaction *)transaction;

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredInternalError:(NSError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiClientError:(WALApiClientError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiServerError:(WALApiServerError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiNetworktError:(NSError*)error;
@end
