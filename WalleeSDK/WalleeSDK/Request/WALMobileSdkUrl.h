//
//  WALMobileSdkUrl.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 19.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALTypes.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT WALTimestamp const WalleeMobileSdkUrlExpiryTime;
FOUNDATION_EXPORT WALTimestamp const WalleeMobileSdkUrlThreshold;

@interface WALMobileSdkUrl : NSObject<NSCopying>
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, readonly) NSUInteger expiryDate;
@property (nonatomic, readonly) BOOL isExpired;

+ (instancetype)mobileSdkUrlWith:(NSString *)mobileSdkUrl expiryDate:(WALTimestamp)expiryDate error:(NSError**)error;
//#include "WALAPIDataType.h"

/**
  This method constructs a new URL which is usable to load the payment form for the provided
  @c paymentMethodConfigurationId.
 
  @param paymentMethodConfigurationId the payment method configuration id for which the URL
                                      should be created for.
  @return the newly created Uri which can be used to load a @c UIWebView.
 */
- (NSURL *)buildPaymentMethodUrl:(NSUInteger)paymentMethodConfigurationId error:(NSError **)error;

NS_ASSUME_NONNULL_END
@end
