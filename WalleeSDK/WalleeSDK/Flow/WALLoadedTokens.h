//
//  WALLoadedTokens.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTokenVersion, WALPaymentMethodConfiguration, WALPaymentMethodIcon;

@interface WALLoadedTokens : NSObject
@property (nonatomic, copy, readonly) NSArray<WALTokenVersion *> *tokenVersions;
@property (nonatomic, copy, readonly) NSDictionary<WALPaymentMethodConfiguration *, WALPaymentMethodIcon *> *paymentMethodIcons;
@end
