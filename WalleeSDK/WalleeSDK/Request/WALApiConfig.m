//
//  WALApiConfig.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALApiConfig.h"

NSString *const WalleeBaseUrl = @"https://app-wallee.com/api/";
NSString *const WalleeEndpointBuildMobilUrl = @"transaction/buildMobileSdkUrlWithCredentials";
NSString *const WalleeEndpointFetchPossiblePaymentMethods = @"transaction/fetchPossiblePaymentMethodsWithCredentials";
NSString *const WalleeEndpointFetchTokenVersion = @"transaction/fetchOneClickTokensWithCredentials";
NSString *const WalleeEndpointReadTransaction = @"transaction/readWithCredentials";
NSString *const WalleeEndpointPerformOneClickToken = @"transaction/processOneClickTokenWithCredentials";

NSString *const WalleeAcceptHeader = @"acceptHeader";
NSString *const WalleeAllowedPaymentMethodBrands = @"allowedPaymentMethodBrands";
NSString *const WalleeAllowedPaymentMethodConfigurations = @"allowedPaymentMethodConfigurations";
NSString *const WalleeAuthorizationAmount = @"authorizationAmount";
NSString *const WalleeAuthorizedOn = @"authorizedOn";
NSString *const WalleeBillingAddress = @"billingAddress";
NSString *const WalleeChargeRetryEnabled = @"chargeRetryEnabled";
NSString *const WalleeCompletedOn = @"completedOn";
NSString *const WalleeCompletionTimeoutOn = @"completionTimeoutOn";
NSString *const WalleeConfirmedBy = @"confirmedBy";
NSString *const WalleeConfirmedOn = @"confirmedOn";
NSString *const WalleeCreatedBy = @"createdBy";
NSString *const WalleeCreatedOn = @"createdOn";
NSString *const WalleeCurrency = @"currency";
NSString *const WalleeCustomerEmailAddress = @"customerEmailAddress";
NSString *const WalleeCustomerId = @"customerId";
NSString *const WalleeCustomersPresence = @"customersPresence";
NSString *const WalleeEndOfLife = @"endOfLife";
NSString *const WalleeFailedOn = @"failedOn";
NSString *const WalleeFailedUrl = @"failedUrl";
NSString *const WalleeFailureReason = @"failureReason";
NSString *const WalleeGroup = @"group";
NSString *const WalleeId = @"id";
NSString *const WalleeObjectId = @"objectId";
NSString *const WalleeInternetProtocolAddress = @"internetProtocolAddress";
NSString *const WalleeInternetProtocolAddressCountry = @"internetProtocolAddressCountry";
NSString *const WalleeInvoiceMerchantReference = @"invoiceMerchantReference";
NSString *const WalleeLanguage = @"language";
NSString *const WalleeLineItems = @"lineItems";
NSString *const WalleeLinkedSpaceId = @"linkedSpaceId";
NSString *const WalleeMerchantReference = @"merchantReference";
NSString *const WalleeMetaData = @"metaData";
NSString *const WalleePaymentConnectorConfiguration = @"paymentConnectorConfiguration";
NSString *const WalleePlannedPurgeDate = @"plannedPurgeDate";
NSString *const WalleeProcessingOn = @"processingOn";
NSString *const WalleeRefundedAmount = @"refundedAmount";
NSString *const WalleeShippingAddress = @"shippingAddress";
NSString *const WalleeShippingMethod = @"shippingMethod";
NSString *const WalleeSpaceViewId = @"spaceViewId";
NSString *const WalleeState = @"state";
NSString *const WalleeSuccessUrl = @"successUrl";
NSString *const WalleeToken = @"token";
NSString *const WalleeUserAgentHeader = @"userAgentHeader";
NSString *const WalleeUserFailureMessage = @"userFailureMessage";
NSString *const WalleeUserInterfaceType = @"userInterfaceType";
NSString *const WalleeVersion = @"version";

NSString *const WalleeDate = @"date";
NSString *const WalleeDefaultMessage = @"defaultMessage";
NSString *const WalleeMessage = @"message";
NSString *const WalleeType = @"type";

NSString *const WalleeName = @"name";
NSString *const WalleeApplicableForTransactionProcessing = @"applicableForTransactionProcessing";
NSString *const WalleeConditions = @"conditions";
NSString *const WalleeConnector = @"connector";
NSString *const WalleeEnabledSpaceViews = @"enabledSpaceViews";
NSString *const WalleePaymentMethodConfiguration = @"paymentMethodConfiguration";
NSString *const WalleePriority = @"priority";
NSString *const WalleeProcessorConfiguration = @"processorConfiguration";


NSUInteger const WalleClientErrorReturnCode = 442;
NSUInteger const WalleServerErrorReturnCode = 542;

@implementation WALApiConfig

@end
