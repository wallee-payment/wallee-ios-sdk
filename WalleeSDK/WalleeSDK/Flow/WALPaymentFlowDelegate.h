//
//  WALFlowListener.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowCoordinator, WALApiClientError;

/**
 *
 */
@protocol WALPaymentFlowDelegate <NSObject>

- (void)flowCoordinatorWillLoadToken:(WALFlowCoordinator *)coordinator;

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredApiClientError:(WALApiClientError*)error;
@end
