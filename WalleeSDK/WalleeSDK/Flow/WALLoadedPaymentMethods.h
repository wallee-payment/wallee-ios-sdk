//
//  WALLoadedPaymentMethods.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALPaymentMethodConfiguration, WALPaymentMethodIcon;

@interface WALLoadedPaymentMethods : NSObject <NSCopying>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) NSArray<WALPaymentMethodConfiguration *> *paymentMethodConfigurations;
@property (nonatomic, copy, readonly) NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *paymentMethodIcons;

- (instancetype)initWithPaymentMethodConfigurations:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethodConfigurations paymentMethodIcons:(NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *)paymentMethodIcons ;
NS_ASSUME_NONNULL_END
@end
