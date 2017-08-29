//
//  PaymentMethodConfiguration.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodConfiguration.h"
#import "WALDatabaseTranslatedString.h"
#import "WALErrorDomain.h"
#import "WALJSONParser.h"

@interface WALPaymentMethodConfiguration ()
- (instancetype) initInternal;
+ (WALDataCollectionType)dataCollectionTypeFrom:(NSString*)name;
+ (NSString *)stringFrom:(WALDataCollectionType)dataCollectionType;
+ (NSDictionary<NSString*, NSNumber*> *)dataCollectionTypeToStringMapping;
@end

@implementation WALPaymentMethodConfiguration

- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALPaymentMethodConfiguration *configuration = [[WALPaymentMethodConfiguration alloc] initInternal];
    if (![WALJSONParser populate:configuration withDictionary:dictionary error:error]) {
        return nil;
    }
    return configuration;
}

// MARK: - JSONAutoDecoding
+ (NSArray<NSString*> *)jsonMapping {
    return @[ @"id", @"linkedSpaceId", @"name", @"paymentMethod", @"plannedPurgeDate", @"resolvedDescription", @"resolvedDescription", @"resolvedImageUrl",@"resolvedTitle",@"sortOrder", @"spaceId", @"version"];
}

+ (NSDictionary<NSString *, Class> *)jsonComplexMapping {
    return @{@"descriptionText": WALDatabaseTranslatedString.class, @"title": WALDatabaseTranslatedString.class};
}

+ (NSDictionary<NSString*,NSString*> *)jsonReMapping {
    return @{@"descriptionText": @"description"};
}

// MARK: - Enums
/*!
 * parses the given @c NSString into the corresponding @c WALDataCollectionType.  
 *
 * @see getDataCollectionTypeToStringMapping
 * @param name named @c WALDataCollectionType
 * @return corresponding @c WALDataCollectionType or @c WALDataCollectionTypeUnknown if no match is found
 */
+ (WALDataCollectionType)dataCollectionTypeFrom:(NSString *)name {
    NSNumber *rawDataType = [self dataCollectionTypeToStringMapping][name.uppercaseString];
    if (rawDataType) {
        return (WALDataCollectionType)rawDataType.integerValue;
    }
    return WALDataCollectionTypeUnknown;
}

+ (NSString *)stringFrom:(WALDataCollectionType)dataCollectionType {
    return [[self getDataCollectionTypeToStringMapping] allKeysForObject:@(dataCollectionType)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)dataCollectionTypeToStringMapping {
    return @{@"ONSITE": @(WALDataCollectionTypeOnsite), @"OFFSITE": @(WALDataCollectionTypeOffsite)};
}

// MARK: - Description
- (NSString *)description {
    NSDictionary *desc = @{
                           @"name": _name,
                           @"id": @(_id),
                           @"spaceId": @(_linkedSpaceId),
                           @"dataCollectionType": [self.class stringFrom:_dataCollectionType],
                           @"paymentMethod": @(_paymentMethod),
                           @"title": _resolvedTitle,
                           @"description": _resolvedDescription,
                           @"imageUrl": _resolvedImageUrl,
                           @"version": @(_version)
                           };
    return [NSString stringWithFormat:@"%@", desc];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}
@end
