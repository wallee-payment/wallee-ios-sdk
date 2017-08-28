//
//  WALTransaction.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"
@class WALFailureReason, WALToken;


@interface WALTransaction : NSObject<WALJSONDecodable, WALJSONAutoDecodable>

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly, copy) NSString *acceptHeader;
//private List<PaymentMethodBrand> allowedPaymentMethodBrands;
//private List<Long> allowedPaymentMethodConfigurations;
@property (nonatomic, readonly) float authorizationAmount;
@property (nonatomic, readonly, copy) NSString *authorizedOn;
//private Address billingAddress;
@property (nonatomic, readonly) BOOL chargeRetryEnabled;
@property (nonatomic, readonly, copy) NSString *completedOn;
@property (nonatomic, readonly, copy) NSString *completionTimeoutOn;
@property (nonatomic, readonly) NSUInteger confirmedBy;
@property (nonatomic, readonly, copy) NSString *confirmedOn;
@property (nonatomic, readonly) NSUInteger createdBy;
@property (nonatomic, readonly, copy) NSString *createdOn;
@property (nonatomic, readonly, copy) NSString *currency;
@property (nonatomic, readonly, copy) NSString *customerEmailAddress;
@property (nonatomic, readonly, copy) NSString *customerId;
//private CustomersPresence customersPresence;
@property (nonatomic, readonly, copy) NSString *endOfLife;
@property (nonatomic, readonly, copy) NSString *failedOn;
@property (nonatomic, readonly, copy) NSString *failedUrl;
@property (nonatomic, readonly, copy) WALFailureReason *failureReason;
//private TransactionGroup group;
@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly, copy) NSString *internetProtocolAddress;
@property (nonatomic, readonly, copy) NSString *internetProtocolAddressCountry;
@property (nonatomic, readonly, copy) NSString *invoiceMerchantReference;
@property (nonatomic, readonly, copy) NSString *language;
//private List<LineItem> lineItems;
@property (nonatomic, readonly) NSUInteger linkedSpaceId;
@property (nonatomic, readonly, copy) NSString *merchantReference;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *metaData;
//private ConnectorConfiguration paymentConnectorConfiguration;
@property (nonatomic, readonly, copy) NSString *plannedPurgeDate;
@property (nonatomic, readonly, copy) NSString *processingOn;
@property (nonatomic, readonly) float refundedAmount;
//private Address shippingAddress;
@property (nonatomic, readonly, copy) NSString *shippingMethod;
@property (nonatomic, readonly) NSUInteger spaceViewId;
//private TransactionState state;
@property (nonatomic, readonly, copy) NSString *successUrl;
@property (nonatomic, readonly, copy) WALToken *token;
@property (nonatomic, readonly, copy) NSString *userAgentHeader;
@property (nonatomic, readonly, copy) NSString *userFailureMessage;
//private TransactionUserInterfaceType userInterfaceType;
@property (nonatomic, readonly) NSUInteger version;

NS_ASSUME_NONNULL_END
@end
