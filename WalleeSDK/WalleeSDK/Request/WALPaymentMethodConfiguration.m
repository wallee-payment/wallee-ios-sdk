//
//  PaymentMethodConfiguration.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodConfiguration.h"
#import "WALDatabaseTranslatedString.h"

@interface WALPaymentMethodConfiguration ()
+ (WALDataCollectionType)dataCollectionTypeFrom:(NSString*)name;
+ (NSString *)stringFrom:(WALDataCollectionType)dataCollectionType;
+ (NSDictionary<NSString*, NSNumber*> *)getDataCollectionTypeToStringMapping;
- (BOOL)populateWithJson:(NSDictionary *)dictionary error:(NSError **)error;
@end

@implementation WALPaymentMethodConfiguration

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALPaymentMethodConfiguration *configuration = [WALPaymentMethodConfiguration new];
    if (![configuration populateWithJson:dictionary error:error]) {
        return nil;
    }
    return configuration;
}

- (BOOL)populateWithJson:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error {
    _dataCollectionType = [self.class dataCollectionTypeFrom:dictionary[@"dataCollectionType"]];
    _descriptionText = [WALDatabaseTranslatedString decodedObjectFromJSON:dictionary[@"description"] error:error];
    _id = [dictionary[@"id"] integerValue];
//    [dictionary[@""] integerValue]; imageResourcePath
    _linkedSpaceId = [dictionary[@"linkedSpaceId"] integerValue];
    _name = dictionary[@"name"];
//    [dictionary[@""] integerValue];oneClickPaymentMethode
    _paymentMethod = [dictionary[@"paymentMethod"] integerValue];
    _plannedPurgeDate = dictionary[@"plannedPurgeDate"];
    _resolvedDescription = dictionary[@"resolvedDescription"];
    _resolvedImageUrl = dictionary[@"resolvedImageUrl"];
    _resolvedTitle = dictionary[@"resolvedTitle"];
    _sortOrder = [dictionary[@"sortOrder"] integerValue];
    _spaceId = [dictionary[@"spaceId"] integerValue];
    _title = [WALDatabaseTranslatedString decodedObjectFromJSON:dictionary[@"title"] error:error];
    _version = [dictionary[@"version"] integerValue];
    return _title != nil && _descriptionText != nil;
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
    NSNumber *rawDataType = [self getDataCollectionTypeToStringMapping][name.uppercaseString];
    if (rawDataType) {
        return (WALDataCollectionType)rawDataType.integerValue;
    }
    return WALDataCollectionTypeUnknown;
}

+ (NSString *)stringFrom:(WALDataCollectionType)dataCollectionType {
    return [[self getDataCollectionTypeToStringMapping] allKeysForObject:@(dataCollectionType)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)getDataCollectionTypeToStringMapping {
    return @{@"ONSITE": @(WALDataCollectionTypeOnsite), @"OFFSITE": @(WALDataCollectionTypeOffsite)};
}

// MARK: - Description
- (NSString *)description {
    NSDictionary *desc = @{
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
