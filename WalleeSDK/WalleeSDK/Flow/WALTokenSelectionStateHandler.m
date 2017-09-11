//
//  WALTokenSelectionStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenSelectionStateHandler.h"
#import "WALFlowConfiguration.h"
#import "WALFlowCoordinator+StateDelegate.h"
#import "WALFlowStateDelegate.h"
#import "WALPaymentFlowDelegate.h"
#import "WALViewControllerFactory.h"

#import "WALPaymentErrorHelper.h"
#import "WALErrorDomain.h"

#import "WALApiClient.h"
#import "WALLoadedTokens.h"
#import "WALTokenVersion.h"
#import "WALTransaction.h"

@interface WALTokenSelectionStateHandler ()
@property (nonatomic, copy) WALLoadedTokens *loadedTokens;
@end

@implementation WALTokenSelectionStateHandler
+ (instancetype)statetWithTokens:(WALLoadedTokens *)loadedTokens {
    if (!loadedTokens.tokenVersions || loadedTokens.tokenVersions.count <= 0) {
        return nil;
    }
    return [[self alloc] initWithTokens:loadedTokens];
}

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self statetWithTokens:parameters[WALFlowTokensParameter]];
}

- (instancetype)initWithTokens:(WALLoadedTokens *)loadedTokens {
    if (self = [super init]) {
        _loadedTokens = loadedTokens;
    }
    return self;
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return flowAction == WALFlowActionSwitchToPaymentMethodSelection;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
    if (![WALSimpleFlowStateHandler isStateValid:self WithCoordinator:coordinator]) {
        return NO;
    }
    if(flowAction == WALFlowActionSwitchToPaymentMethodSelection) {
        [coordinator changeStateTo:WALFlowStatePaymentMethodLoading parameters:nil];
        return YES;
    }
    return NO;
}

- (void)performWithCoordinator:(WALFlowCoordinator *)coordinator {
    [super performWithCoordinator:coordinator];
    if ([coordinator.configuration.delegate respondsToSelector:@selector(flowCoordinatorWillDisplayTokenSelection:)]) {
        [coordinator.configuration.delegate flowCoordinatorWillDisplayTokenSelection:coordinator];
    }
    [coordinator ready];
}

- (UIViewController *)viewControllerForCoordinator:(WALFlowCoordinator *)coordinator {
    __weak WALTokenSelectionStateHandler *weakSelf = self;
    __weak WALFlowCoordinator *weakCoordinator = coordinator;
    WALTransactionCompletion transactionCompletion = ^(WALTransaction * _Nullable transaction, NSError * _Nullable error) {
        if (transaction) {
            NSDictionary *params = @{WALFlowTransactionParameter: transaction};
            if (transaction.isSuccessful) {
                [weakCoordinator changeStateTo:WALFlowStateSuccess parameters:params];
            } else if(transaction.isFailed) {
                [weakCoordinator changeStateTo:WALFlowStateFailure parameters:params];
            } else {
                [weakCoordinator changeStateTo:WALFlowStateAwaitingFinalState parameters:params];
            }
        } else {
            [WALPaymentErrorHelper distributeNetworkError:error forCoordinator:weakCoordinator];
        }
    };
    
    WALTokenVersionSelected tokenSelected = ^(WALTokenVersion * _Nonnull selectedToken) {
        NSError *error;
        if (![WALErrorHelper checkNotEmpty:weakSelf withMessage:@"Trying to run Action on invalidated StateHandler" error:&error]) {
            [WALPaymentErrorHelper distribute:error forCoordinator:weakCoordinator];
            return;
        }
        if (![WALErrorHelper checkNotEmpty:selectedToken withMessage:@"TokenVersion is required. Cannot be nil" error:&error] ||
            ![WALErrorHelper checkNotEmpty:selectedToken.token withMessage:@"Token is required. Cannot be nil" error:&error]) {
            [WALPaymentErrorHelper distribute:error forCoordinator:weakCoordinator];
            return;
        }
        
        [weakCoordinator waiting];
        
        if ([weakCoordinator.configuration.delegate respondsToSelector:@selector(flowCoordinator:didSelectToken:)]) {
            [weakCoordinator.configuration.delegate flowCoordinator:weakCoordinator didSelectToken:selectedToken];
        }
        
        [weakCoordinator.configuration.webServiceApiClient processOneClickToken:selectedToken.token completion:transactionCompletion];
    };
    
    WALOnBackBlock paymentMethodChange = ^(void) {
        WALFlowCoordinator *strongCoordinator = weakCoordinator;
        WALTokenSelectionStateHandler *strongSelf = weakSelf;
        
        if (![WALSimpleFlowStateHandler isStateValid:strongSelf WithCoordinator:strongCoordinator]) {
            return;
        }
        
        [strongSelf triggerAction:WALFlowActionSwitchToPaymentMethodSelection WithCoordinator:strongCoordinator];
    };
    
    UIViewController *controller = [coordinator.configuration.viewControllerFactory buildTokenListViewWith:self.loadedTokens onSelection:tokenSelected onChangePaymentMethod:paymentMethodChange];
    return controller;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"TokenSelection", @"Tokens": self.loadedTokens}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
