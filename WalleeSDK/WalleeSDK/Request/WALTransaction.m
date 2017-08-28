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
             WalleeConfirmedBy, WalleeConfirmedOn, WalleeCreatedOn, WalleeCreatedBy, WalleeCreatedOn,
             WalleeCurrency, WalleeCustomerEmailAddress, WalleeCustomerId,
             WalleeEndOfLife, WalleeFailedOn, WalleeFailedUrl, WalleeId,
             WalleeInternetProtocolAddress, WalleeInternetProtocolAddressCountry,
             WalleeInvoiceMerchantReference, WalleeLanguage, WalleeSpaceViewId, WalleeInvoiceMerchantReference,
             WalleeMetaData, WalleePlannedPurgeDate, WalleeProcessingOn,
             WalleeRefundedAmount, WalleeShippingMethod, WalleeSpaceViewId,
             WalleeSuccessUrl, WalleeUserAgentHeader, WalleeUserFailureMessage, WalleeVersion];
}
+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return @{WalleeFailureReason: WALFailureReason.class, WalleeToken: WALToken.class};
}
+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}
@end
