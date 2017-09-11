//
//  WALLoadedTokens.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALLoadedTokens.h"

@interface WALLoadedTokens ()
@property (nonatomic, copy, readwrite) NSArray<WALTokenVersion *> *tokenVersions;
@property (nonatomic, copy, readwrite) NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *paymentMethodIcons;

@end

@implementation WALLoadedTokens
- (instancetype)initWithTokenVersions:(NSArray<WALTokenVersion *> *)tokenVersions paymentMethodIcons:(NSDictionary<WALPaymentMethodConfiguration *,WALPaymentMethodIcon *> *)paymentMethodIcons {
    
    if (self = [super init]) {
        _tokenVersions = tokenVersions.copy;
        _paymentMethodIcons = paymentMethodIcons.copy;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WALLoadedTokens *tokens = [[self.class allocWithZone:zone] initWithTokenVersions:self.tokenVersions paymentMethodIcons:self.paymentMethodIcons];
    return tokens;
}

@end
