//
//  WALLoadedPaymentMethods.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALLoadedPaymentMethods.h"
@interface WALLoadedPaymentMethods ()
@property (nonatomic, copy, readwrite) NSArray<WALPaymentMethodConfiguration *> *paymentMethodConfigurations;
@property (nonatomic, copy, readwrite) NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *paymentMethodIcons;
@end

@implementation WALLoadedPaymentMethods

- (instancetype)initWithPaymentMethodConfigurations:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethodConfigurations paymentMethodIcons:(NSDictionary<WALPaymentMethodConfiguration *,WALPaymentMethodIcon *> *)paymentMethodIcons {
    if (self = [super init]) {
        _paymentMethodConfigurations = paymentMethodConfigurations.copy;
        _paymentMethodIcons = paymentMethodIcons.copy;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WALLoadedPaymentMethods *methods = [[self.class allocWithZone:zone] initWithPaymentMethodConfigurations:self.paymentMethodConfigurations paymentMethodIcons:self.paymentMethodIcons];
    return methods;
}

@end
