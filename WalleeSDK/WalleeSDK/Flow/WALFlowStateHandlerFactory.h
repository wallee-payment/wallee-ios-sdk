//
//  WALFlowStateHandlerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALFlowEnums.h"
@protocol WALFlowStateHandler;

@interface WALFlowStateHandlerFactory : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (id<WALFlowStateHandler>)handlerFromState:(WALFlowState)state;
NS_ASSUME_NONNULL_END
@end
