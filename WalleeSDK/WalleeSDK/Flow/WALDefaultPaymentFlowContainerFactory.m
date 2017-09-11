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
- (id<WALPaymentFlowContainer>)buildWithBackAction:(WALContainerBackAction)onBackAction {
    UIViewController *emptyRoot = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    emptyRoot.view.backgroundColor = UIColor.whiteColor;
    WALDefaultPaymentFlowContainer *container = [[WALDefaultPaymentFlowContainer alloc] initWithRootViewController:emptyRoot backAction:onBackAction];
    return container;
}
@end
