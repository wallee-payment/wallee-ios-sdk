//
//  WALIconLoader.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALPaymentMethodConfiguration, WALPaymentMethodIcon;

typedef void(^WALPaymentIconCompletion)(WALPaymentMethodConfiguration * _Nullable paymentMethod, WALPaymentMethodIcon * _Nullable paymentMethodIcon, NSError * _Nullable error);

@protocol WALIconLoader <NSObject>
- (void)fetchIcon:(WALPaymentMethodConfiguration*_Nonnull)paymentMethodConfiguration completion:(WALPaymentIconCompletion _Nullable )completion;
@end
