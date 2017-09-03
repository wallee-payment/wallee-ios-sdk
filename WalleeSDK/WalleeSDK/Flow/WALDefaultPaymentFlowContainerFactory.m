//
//  WALDefaultPaymentFlowContainerFactory.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultPaymentFlowContainerFactory.h"
#import "WALDefaultPaymentFlowContainer.h"

@implementation WALDefaultPaymentFlowContainerFactory
- (id<WALPaymentFlowContainer>)build {
    WALDefaultPaymentFlowContainer *container = [[WALDefaultPaymentFlowContainer alloc] initWithRootViewController:[[UIViewController alloc] initWithNibName:nil bundle:nil]];
    return container;
}
@end
