//
//  WALIconCache.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALPaymentMethodConfiguration, WALPaymentMethodIcon;


typedef void(^WALPaymentIconsFetched)(NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> * _Nonnull paymentMethodIcons, NSError * _Nullable error);

@protocol WALIconCache <NSObject>
NS_ASSUME_NONNULL_BEGIN
- (void)fetchIcons:(NSArray<WALPaymentMethodConfiguration *> *)paymentMethodConfigurations completion:(WALPaymentIconsFetched)completion;
NS_ASSUME_NONNULL_END
@end
