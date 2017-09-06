//
//  WALPaymentErrorHelper.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentErrorHelper.h"
#import "WALApiClientError.h"
#import "WALApiServerError.h"
#import "WALFlowCoordinator.h"
#import "WALFlowConfiguration.h"
#import "WALPaymentFlowDelegate.h"

@implementation WALPaymentErrorHelper
+ (void)distributeNetworkError:(NSError *)error forCoordinator:(WALFlowCoordinator *)coordinator {
    if (!error || !coordinator) {
        return;
    }
    if ([error isKindOfClass:WALApiServerError.class]) {
        [coordinator.configuration.delegate flowCoordinator:coordinator encouteredApiServerError:(WALApiServerError *)error];
    } else if ([error isKindOfClass:WALApiClientError.class]) {
        [coordinator.configuration.delegate flowCoordinator:coordinator encouteredApiClientError:(WALApiClientError *)error];
    } else {
        [coordinator.configuration.delegate flowCoordinator:coordinator encouteredApiNetworktError:error];
    }
}

+ (void)distribute:(NSError *)error forCoordinator:(WALFlowCoordinator *)coordinator {
    [coordinator.configuration.delegate flowCoordinator:coordinator encouteredInternalError:error];
}
@end
