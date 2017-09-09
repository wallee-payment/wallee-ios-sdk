//
//  WALLoadedTokens.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTokenVersion, WALPaymentMethodConfiguration, WALPaymentMethodIcon;

@interface WALLoadedTokens : NSObject<NSCopying>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) NSArray<WALTokenVersion *> *tokenVersions;
@property (nonatomic, copy, readonly) NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *paymentMethodIcons;

- (instancetype)initWithTokenVersions:(NSArray<WALTokenVersion *> *)tokenVersions paymentMethodIcons:(NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *)paymentMethodIcons ;
NS_ASSUME_NONNULL_END
@end
