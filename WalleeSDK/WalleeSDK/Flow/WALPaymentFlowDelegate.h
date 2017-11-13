//
//  WALFlowListener.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowCoordinator, WALApiClientError, WALApiServerError, WALTokenVersion, WALTransaction, WALPaymentMethodConfiguration;

/**
 *
 */
@protocol WALPaymentFlowDelegate <NSObject>

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidSucceed:(WALTransaction *)transaction;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidCancel:(WALTransaction *)transaction;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidFail:(WALTransaction *)transaction;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredInternalError:(NSError*)error;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiError:(NSError*)error;

@optional
- (void)flowCoordinatorWillLoadToken:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinatorWillDisplayTokenSelection:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator didSelectToken:(WALTokenVersion *)token;

- (void)flowCoordinatorWillLoadPaymentMethod:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinatorWillDisplayPaymentMethodSelection:(WALFlowCoordinator *)coordinator;
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator didSelectPaymentMethod:(WALPaymentMethodConfiguration *)paymentMethod;

@end
