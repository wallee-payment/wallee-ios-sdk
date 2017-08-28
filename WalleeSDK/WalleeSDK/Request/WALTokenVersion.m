//
//  WALToken.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenVersion.h"
#import "WALJSONParser.h"
#import "WALToken.h"

static NSString * const walActivatedOn = @"activatedOn";
static NSString * const walCreatedOn = @"createdOn";
static NSString * const walId = @"id";
static NSString * const walLanguage = @"language";
static NSString * const walLinkedSpaceId = @"linkedSpaceId";
static NSString * const walName = @"name";
static NSString * const walObsoletedOn = @"obsoletedOn";
static NSString * const walPaymentConnectorConfiguration = @"paymentConnectorConfiguration";
static NSString * const walPlannedPurgeDate = @"plannedPurgeDate";
static NSString * const walProcessorToken = @"processorToken";
static NSString * const walVersion = @"version";
static NSString * const walToken = @"token";
static NSString * const walBillingAddress = @"billingAddress";
static NSString * const walEnvironment = @"environment";
static NSString * const walLabels = @"labels";
static NSString * const walShippingAddress = @"shippingAddress";
static NSString * const walState = @"state";

@implementation WALTokenVersion

- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALTokenVersion *tokenVersion = [[WALTokenVersion alloc] initInternal];
    if (![WALJSONParser populate:tokenVersion withDictionary:dictionary error:error]) {
        return nil;
    }
    return tokenVersion;
}

+(NSArray<NSString *> *)jsonMapping {
    return @[walActivatedOn, walCreatedOn, walId, walLanguage, walLinkedSpaceId, walName, walObsoletedOn, walPlannedPurgeDate, walProcessorToken, walVersion];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return @{walToken: WALToken.class};
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}
@end
