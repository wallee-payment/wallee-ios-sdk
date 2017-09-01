//
//  WALFlowViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WALPaymentFlowContainer;

@protocol WALPaymentFlowContainerFactory <NSObject>
- (id<WALPaymentFlowContainer>)build;
@end
