//
//  WALPaymentErrorHelper.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALFlowCoordinator;

@interface WALPaymentErrorHelper : NSObject
+ (void)distributeNetworkError:(NSError *_Nonnull)error forCoordinator:(WALFlowCoordinator * _Nonnull)coordinator;

+ (void)distribute:(NSError *_Nonnull)error forCoordinator:(WALFlowCoordinator * _Nonnull)coordinator;

@end
