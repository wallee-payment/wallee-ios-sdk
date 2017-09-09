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

- (instancetype)initWithTokenVersions:(NSArray<WALTokenVersion *> *)tokenVersions paymentMethodIcons:(NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *)paymentMethodIcons {
    
    if (self = [super init]) {
        
    }
    return self;
}

@end
