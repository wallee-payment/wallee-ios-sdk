//
//  PaymentMethodConfiguration.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodConfiguration.h"

@interface WALPaymentMethodConfiguration ()
- (void)populateWithJson:(NSDictionary *)dictionary;
@end

@implementation WALPaymentMethodConfiguration

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary {
    WALPaymentMethodConfiguration *configuration = [WALPaymentMethodConfiguration new];
    [configuration populateWithJson:dictionary];
    return configuration;
}

- (void)populateWithJson:(NSDictionary *)dictionary {
    NSString *spId = dictionary[@"linkedSpaceId"];
    _linkedSpaceId = spId.integerValue;
    _name = dictionary[@"name"];
}

@end
