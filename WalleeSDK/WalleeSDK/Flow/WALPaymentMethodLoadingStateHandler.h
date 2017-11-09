//
//  WALPaymentMethodLoadingStateHandler.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowStateHandler.h"
#import "WALSimpleFlowStateHandler.h"
#import "WALLoadedTokens.h"

@interface WALPaymentMethodLoadingStateHandler : WALSimpleFlowStateHandler<WALFlowStateHandler>
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)stateWithTokens:(WALLoadedTokens *)loadedTokens;
NS_ASSUME_NONNULL_END
@end
