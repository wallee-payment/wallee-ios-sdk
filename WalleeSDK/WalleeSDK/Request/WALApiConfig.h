//
//  WALApiConfig.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const WalleeBaseUrl;
FOUNDATION_EXPORT NSString *const WalleeEndpointBuildMobilUrl;
FOUNDATION_EXPORT NSString *const WalleeEndpointFetchPossiblePaymentMethods;
FOUNDATION_EXPORT NSString *const WalleeEndpointFetchTokenVersion;
FOUNDATION_EXPORT NSString *const WalleeEndpointReadTransaction;
FOUNDATION_EXPORT NSString *const WalleeEndpointPerformOneClickToken;

FOUNDATION_EXPORT NSString *const WalleeAcceptHeader;
FOUNDATION_EXPORT NSString *const WalleeAllowedPaymentMethodBrands;
FOUNDATION_EXPORT NSString *const WalleeAllowedPaymentMethodConfigurations;
FOUNDATION_EXPORT NSString *const WalleeAuthorizationAmount;
FOUNDATION_EXPORT NSString *const WalleeAuthorizedOn;
FOUNDATION_EXPORT NSString *const WalleeBillingAddress;
FOUNDATION_EXPORT NSString *const WalleeChargeRetryEnabled;
FOUNDATION_EXPORT NSString *const WalleeCompletedOn;
FOUNDATION_EXPORT NSString *const WalleeCompletionTimeoutOn;
FOUNDATION_EXPORT NSString *const WalleeConfirmedBy;
FOUNDATION_EXPORT NSString *const WalleeConfirmedOn;
FOUNDATION_EXPORT NSString *const WalleeCreatedBy;
FOUNDATION_EXPORT NSString *const WalleeCreatedOn;
FOUNDATION_EXPORT NSString *const WalleeCurrency;
FOUNDATION_EXPORT NSString *const WalleeCustomerEmailAddress;
FOUNDATION_EXPORT NSString *const WalleeCustomerId;
FOUNDATION_EXPORT NSString *const WalleeCustomersPresence;
FOUNDATION_EXPORT NSString *const WalleeEndOfLife;
FOUNDATION_EXPORT NSString *const WalleeFailedOn;
FOUNDATION_EXPORT NSString *const WalleeFailedUrl;
FOUNDATION_EXPORT NSString *const WalleeFailureReason;
FOUNDATION_EXPORT NSString *const WalleeGroup;
FOUNDATION_EXPORT NSString *const WalleeId;
FOUNDATION_EXPORT NSString *const WalleeObjectId;
FOUNDATION_EXPORT NSString *const WalleeInternetProtocolAddress;
FOUNDATION_EXPORT NSString *const WalleeInternetProtocolAddressCountry;
FOUNDATION_EXPORT NSString *const WalleeInvoiceMerchantReference;
FOUNDATION_EXPORT NSString *const WalleeLanguage;
FOUNDATION_EXPORT NSString *const WalleeLineItems;
FOUNDATION_EXPORT NSString *const WalleeLinkedSpaceId;
FOUNDATION_EXPORT NSString *const WalleeMerchantReference;
FOUNDATION_EXPORT NSString *const WalleeMetaData;
FOUNDATION_EXPORT NSString *const WalleePaymentConnectorConfiguration;
FOUNDATION_EXPORT NSString *const WalleePlannedPurgeDate;
FOUNDATION_EXPORT NSString *const WalleeProcessingOn;
FOUNDATION_EXPORT NSString *const WalleeRefundedAmount;
FOUNDATION_EXPORT NSString *const WalleeShippingAddress;
FOUNDATION_EXPORT NSString *const WalleeShippingMethod;
FOUNDATION_EXPORT NSString *const WalleeSpaceViewId;
FOUNDATION_EXPORT NSString *const WalleeState;
FOUNDATION_EXPORT NSString *const WalleeSuccessUrl;
FOUNDATION_EXPORT NSString *const WalleeToken;
FOUNDATION_EXPORT NSString *const WalleeUserAgentHeader;
FOUNDATION_EXPORT NSString *const WalleeUserFailureMessage;
FOUNDATION_EXPORT NSString *const WalleeUserInterfaceType;
FOUNDATION_EXPORT NSString *const WalleeVersion;

FOUNDATION_EXPORT NSString *const WalleeDate;
FOUNDATION_EXPORT NSString *const WalleeDefaultMessage;
FOUNDATION_EXPORT NSString *const WalleeMessage;
FOUNDATION_EXPORT NSString *const WalleeType;

FOUNDATION_EXPORT NSString *const WalleeName;
FOUNDATION_EXPORT NSString *const WalleeApplicableForTransactionProcessing;
FOUNDATION_EXPORT NSString *const WalleeConditions;
FOUNDATION_EXPORT NSString *const WalleeConnector;
FOUNDATION_EXPORT NSString *const WalleeEnabledSpaceViews;
FOUNDATION_EXPORT NSString *const WalleePaymentMethodConfiguration;
FOUNDATION_EXPORT NSString *const WalleePriority;
FOUNDATION_EXPORT NSString *const WalleeProcessorConfiguration;

FOUNDATION_EXPORT NSUInteger const WalleClientErrorReturnCode;
FOUNDATION_EXPORT NSUInteger const WalleServerErrorReturnCode;

@interface WALApiConfig : NSObject

@end
