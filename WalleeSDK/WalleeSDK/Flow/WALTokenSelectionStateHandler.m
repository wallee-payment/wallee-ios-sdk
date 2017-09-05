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
#import "WALTokenVersion.h"
#import "WALTransaction.h"

@interface WALTokenSelectionStateHandler ()
@property (nonatomic, copy) NSArray<WALTokenVersion *> *tokens;
@end

@implementation WALTokenSelectionStateHandler
+ (instancetype)statetWithTokens:(NSArray<WALTokenVersion *> *)tokens {
    if (!tokens || tokens.count <= 0) {
        return nil;
    }
    return [[self alloc] initWithTokens:tokens];
}

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self statetWithTokens:parameters[WALFlowTokensParameter]];
}

- (instancetype)initWithTokens:(NSArray<WALTokenVersion *> *)tokens {
    if (self = [super init]) {
        _tokens = tokens;
    }
    return self;
}

- (BOOL)dryTriggerAction:(WALFlowAction)flowAction {
    return flowAction == WALFlowActionSwitchToPaymentMethodSelection;
}

- (BOOL)triggerAction:(WALFlowAction)flowAction WithCoordinator:(WALFlowCoordinator *)coordinator {
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
    
    UIViewController *controller = [coordinator.configuration.viewControllerFactory buildTokenListViewWith:self.tokens onSelection:tokenSelected];
    return controller;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"State": @"TokenSelection", @"Tokens": self.tokens}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
