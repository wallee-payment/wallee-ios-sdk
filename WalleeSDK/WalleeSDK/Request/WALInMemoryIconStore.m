//
//  WALInMemoryIconStore.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALInMemoryIconStore.h"
#import "WALPaymentMethodConfiguration.h"

@interface WALInMemoryIconStore ()
@property (nonatomic, strong) NSMutableDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *store;
@end



@implementation WALInMemoryIconStore

- (instancetype)init {
    if (self = [super init]) {
        _store = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (WALPaymentMethodIcon *)getIcon:(WALPaymentMethodConfiguration *)paymentMethod {
    return self.store[paymentMethod];
}

- (void)storeIcon:(WALPaymentMethodIcon *)paymentIcon forPaymentMethodConfiguration:(WALPaymentMethodConfiguration *)paymentMethod {
    self.store[paymentMethod] = paymentIcon;
}

@end
