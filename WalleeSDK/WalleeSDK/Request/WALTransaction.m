//
//  WALTransaction.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTransaction.h"
#import "WALApiConfig.h"
#import "WALJSONParser.h"
#import "WALToken.h"
#import "WALFailureReason.h"

@implementation WALTransaction

- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALTransaction *transaction = [[WALTransaction alloc] initInternal];
    if (![WALJSONParser populate:transaction withDictionary:dictionary error:error]) {
        return nil;
    }
    return transaction;
}

// MARK - JSON
+ (NSArray<NSString *> *)jsonMapping {
    return @[WalleeAcceptHeader, WalleeAuthorizationAmount, WalleeAuthorizedOn,
             WalleeChargeRetryEnabled, WalleeCompletedOn, WalleeCompletionTimeoutOn,
             WalleeConfirmedBy, WalleeConfirmedOn, WalleeCreatedOn, WalleeCreatedBy,
             WalleeCurrency, WalleeCustomerEmailAddress, WalleeCustomerId,
             WalleeEndOfLife, WalleeFailedOn, WalleeFailedUrl, WalleeId,
             WalleeInternetProtocolAddress, WalleeInternetProtocolAddressCountry,
             WalleeInvoiceMerchantReference, WalleeLanguage, WalleeSpaceViewId,
             WalleeMetaData, WalleePlannedPurgeDate, WalleeProcessingOn,
             WalleeRefundedAmount, WalleeShippingMethod,
             WalleeSuccessUrl, WalleeUserAgentHeader, WalleeUserFailureMessage, WalleeVersion];
}
+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return @{WalleeFailureReason: WALFailureReason.class, WalleeToken: WALToken.class};
}
+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}


// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{WalleeAcceptHeader: _acceptHeader, WalleeAuthorizationAmount: @(_authorizationAmount)
                                               , WalleeAuthorizedOn: _authorizedOn, WalleeChargeRetryEnabled: @(_chargeRetryEnabled), WalleeCompletedOn: _completedOn, WalleeCompletionTimeoutOn: _completionTimeoutOn,
                                               WalleeConfirmedBy: @(_confirmedBy), WalleeConfirmedOn: _confirmedOn, WalleeCreatedBy: @(_createdBy), WalleeCreatedOn: _createdOn,
                                               WalleeCurrency: _currency, WalleeCustomerEmailAddress: _customerEmailAddress, WalleeCustomerId: _customerId,
                                               WalleeEndOfLife: _endOfLife, WalleeFailedOn: _failedOn, WalleeFailedUrl: _failedUrl, WalleeId: @(_id),
                                               WalleeInternetProtocolAddress: _internetProtocolAddress, WalleeInternetProtocolAddressCountry: _internetProtocolAddressCountry,
                                               WalleeInvoiceMerchantReference: _merchantReference, WalleeLanguage: _language, WalleeSpaceViewId: @(_spaceViewId), WalleeMetaData: _metaData, WalleePlannedPurgeDate: _plannedPurgeDate, WalleeProcessingOn: _processingOn,
                                               WalleeRefundedAmount: @(_refundedAmount), WalleeShippingMethod: _shippingMethod,
                                               WalleeSuccessUrl: _successUrl, WalleeUserAgentHeader: _userAgentHeader, WalleeUserFailureMessage: _userFailureMessage,
                                               WalleeVersion: @(_version)
                                               }];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}
@end
