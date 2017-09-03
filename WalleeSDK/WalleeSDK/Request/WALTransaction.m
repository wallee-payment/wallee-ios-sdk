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
    [transaction setValue:@([WALTransaction transactionStateFrom:dictionary[WalleeState]]) forKey:WalleeState];
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

// MARK: - Computed Properties
- (BOOL)isAwaitingFinalState {
    return self.state == WALTransactionStatePending || self.state == WALTransactionStateProcessing
    || self.state == WALTransactionStateConfirmed;
}

- (BOOL)isFailed {
    return self.state == WALTransactionStateFailed || self.state == WALTransactionStateDecline;
}

- (BOOL)isSuccessful {
    return self.state == WALTransactionStateAuthorized || self.state == WALTransactionStateCompleted
    || self.state == WALTransactionStateFulfill;
}

// MARK: - Enum
+ (WALTransactionState)transactionStateFrom:(NSString *)name {
    NSNumber *rawDataType = [self transactionStateToStringMapping][name.uppercaseString];
    if (rawDataType) {
        return (WALTransactionState)rawDataType.integerValue;
    }
    return WALTransactionStateUnknown;
}

+ (NSString *)stringFrom:(WALTransactionState)transactionState {
    return [[self transactionStateToStringMapping] allKeysForObject:@(transactionState)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)transactionStateToStringMapping {
    return @{@"CREATE": @(WALTransactionStateCreate),
             @"PENDING": @(WALTransactionStatePending),
             @"CONFIRMED": @(WALTransactionStateConfirmed),
             @"PROCESSING": @(WALTransactionStateProcessing),
             @"FAILED": @(WALTransactionStateFailed),
             @"AUTHORIZED": @(WALTransactionStateAuthorized),
             @"COMPLETED": @(WALTransactionStateCompleted),
             @"FULFILL": @(WALTransactionStateFulfill),
             @"DECLINE": @(WALTransactionStateDecline),
             @"VOIDED": @(WALTransactionStateVoided)};
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{WalleeAcceptHeader: _acceptHeader?: NSNull.null, WalleeAuthorizationAmount: @(_authorizationAmount)
                                               , WalleeAuthorizedOn: _authorizedOn?: NSNull.null, WalleeChargeRetryEnabled: @(_chargeRetryEnabled), WalleeCompletedOn: _completedOn?: NSNull.null, WalleeCompletionTimeoutOn: _completionTimeoutOn?: NSNull.null,
                                               WalleeConfirmedBy: @(_confirmedBy), WalleeConfirmedOn: _confirmedOn?: NSNull.null, WalleeCreatedBy: @(_createdBy), WalleeCreatedOn: _createdOn?: NSNull.null,
                                               WalleeCurrency: _currency?: NSNull.null, WalleeCustomerEmailAddress: _customerEmailAddress?: NSNull.null, WalleeCustomerId: _customerId?: NSNull.null,
                                               WalleeEndOfLife: _endOfLife ?: NSNull.null, WalleeFailedOn: _failedOn ?: NSNull.null, WalleeFailedUrl: _failedUrl ?: NSNull.null, WalleeId: @(_id),
                                               WalleeInternetProtocolAddress: _internetProtocolAddress ?: NSNull.null, WalleeInternetProtocolAddressCountry: _internetProtocolAddressCountry ?: NSNull.null,
                                               WalleeInvoiceMerchantReference: _merchantReference ?: NSNull.null, WalleeLanguage: _language ?: NSNull.null, WalleeSpaceViewId: @(_spaceViewId), WalleeMetaData: _metaData ?: NSNull.null, WalleePlannedPurgeDate: _plannedPurgeDate ?: NSNull.null, WalleeProcessingOn: _processingOn ?: NSNull.null,
                                               WalleeRefundedAmount: @(_refundedAmount), WalleeShippingMethod: _shippingMethod ?: NSNull.null,
                                               WalleeSuccessUrl: _successUrl ?: NSNull.null, WalleeUserAgentHeader: _userAgentHeader ?: NSNull.null, WalleeUserFailureMessage: _userFailureMessage ?: NSNull.null,
                                               WalleeVersion: @(_version)
                                               }];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

// MARK: - Copying
- (id)copyWithZone:(NSZone *)zone {
    WALTransaction *transaction = [[self.class allocWithZone:zone] initInternal];
    
    transaction->_acceptHeader = [_acceptHeader copyWithZone:zone];
//    transaction->_allowedPaymentMethodBrands = [_allowedPaymentMethodBrands copyWithZone:zone];
//    transaction->_allowedPaymentMethodConfigurations = [_allowedPaymentMethodConfigurations copyWithZone:zone];
    transaction->_authorizationAmount = _authorizationAmount;
    transaction->_authorizedOn = [_authorizedOn copyWithZone:zone];
//    transaction->_billingAddress = [_billingAddress copyWithZone:zone];
    transaction->_chargeRetryEnabled = _chargeRetryEnabled;
    transaction->_completedOn = [_completedOn copyWithZone:zone];
    transaction->_completionTimeoutOn = [_completionTimeoutOn copyWithZone:zone];
    transaction->_confirmedBy = _confirmedBy;
    transaction->_confirmedOn = [_confirmedOn copyWithZone:zone];
    transaction->_createdBy = _createdBy;
    transaction->_createdOn = [_createdOn copyWithZone:zone];
    transaction->_currency = [_currency copyWithZone:zone];
    transaction->_customerEmailAddress = [_customerEmailAddress copyWithZone:zone];
    transaction->_customerId = [_customerId copyWithZone:zone];
//    transaction->_customersPresence = [_customersPresence copyWithZone:zone];
    transaction->_endOfLife = [_endOfLife copyWithZone:zone];
    transaction->_failedOn = [_failedOn copyWithZone:zone];
    transaction->_failedUrl = [_failedUrl copyWithZone:zone];
    transaction->_failureReason = [_failureReason copyWithZone:zone];
//    transaction->_group = [_group copyWithZone:zone];
    transaction->_id = _id;
    transaction->_internetProtocolAddress = [_internetProtocolAddress copyWithZone:zone];
    transaction->_internetProtocolAddressCountry = [_internetProtocolAddressCountry copyWithZone:zone];
    transaction->_invoiceMerchantReference = [_invoiceMerchantReference copyWithZone:zone];
    transaction->_language = [_language copyWithZone:zone];
//    transaction->_lineItems = [_lineItems copyWithZone:zone];
    transaction->_linkedSpaceId = _linkedSpaceId;
    transaction->_merchantReference = [_merchantReference copyWithZone:zone];
    transaction->_metaData = [_metaData copyWithZone:zone];
//    transaction->_paymentConnectorConfiguration = [_paymentConnectorConfiguration copyWithZone:zone];
    transaction->_plannedPurgeDate = [_plannedPurgeDate copyWithZone:zone];
    transaction->_processingOn = [_processingOn copyWithZone:zone];
    transaction->_refundedAmount = _refundedAmount;
//    transaction->_shippingAddress = [_shippingAddress copyWithZone:zone];
    transaction->_shippingMethod = [_shippingMethod copyWithZone:zone];
    transaction->_spaceViewId = _spaceViewId;
    transaction->_state = _state;
    transaction->_successUrl = [_successUrl copyWithZone:zone];
    transaction->_token = [_token copyWithZone:zone];
    transaction->_userAgentHeader = [_userAgentHeader copyWithZone:zone];
    transaction->_userFailureMessage = [_userFailureMessage copyWithZone:zone];
//    transaction->_userInterfaceType = [_userInterfaceType copyWithZone:zone];
    transaction->_version = _version;
    return transaction;
}
@end
