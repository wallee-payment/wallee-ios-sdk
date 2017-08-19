//
//  WALMobileSdkUrl.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 19.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALMobileSdkUrl.h"
#import "WALErrorDomain.h"


/// Walle MobileSdkURL expiration time.
WALTimestamp const WalleeMobileSdkUrlExpiryTime = 15 * 60;

/// The threshold which is applied to make sure the URL is valid when it is used.
WALTimestamp const WalleeMobileSdkUrlThreshold = 2 * 60 * 1000;

static NSString * const WallePaymentMethodQueryParamName = @"paymentMethodConfigurationId";

@interface WALMobileSdkUrl ()
@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, readwrite) NSUInteger expiryDate;
@end

@implementation WALMobileSdkUrl

-(instancetype)initWithUrl:(NSString *)url expiryDate:(WALTimestamp)expiryDate {
    self = [self init];
    if (self) {
        _url = url;
        _expiryDate = expiryDate;
    }
    return self;
}

-(BOOL)isExpired {
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    return self.expiryDate - WalleeMobileSdkUrlThreshold < current ;
}

- (NSURL *)buildPaymentMethodUrl:(NSUInteger)paymentMethodConfigurationId error:(NSError * _Nullable __autoreleasing *)error {
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
    if (self.expiryDate < current) {
        [WALErrorHelper populate:error withIllegalStateWithMessage:@"The URL is expired. It cannot be used anymore to create a payment method specific URL."];
        return nil;
    }
    NSURLComponents *components = [NSURLComponents componentsWithString:self.url];
    NSURLQueryItem *paymentParam = [NSURLQueryItem queryItemWithName:WallePaymentMethodQueryParamName value:[NSString stringWithFormat:@"%@", @(paymentMethodConfigurationId)]];
    components.queryItems = [components.queryItems arrayByAddingObject:paymentParam];
    return components.URL;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"url": self.url, @"expiryDate": [NSDate dateWithTimeIntervalSince1970:self.expiryDate]}];
}
- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}
@end
