//
//  WALIconStore.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALPaymentMethodConfiguration, WALPaymentMethodIcon;

@protocol WALIconStore <NSObject>
- (WALPaymentMethodIcon * _Nullable)getIcon:(WALPaymentMethodConfiguration * _Nonnull)paymentMethod;
- (void)storeIcon:(WALPaymentMethodIcon *_Nonnull)paymentIcon forPaymentMethodConfiguration:(WALPaymentMethodConfiguration * _Nonnull)paymentMethod;
@end
