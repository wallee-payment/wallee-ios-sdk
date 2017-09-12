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
#import "WALApiConfig.h"

#import "WALDataObject+Private.h"

@interface WALPaymentMethodConfiguration ()
- (instancetype) initInternal;
+ (WALDataCollectionType)dataCollectionTypeFrom:(NSString*)name;
+ (NSString *)stringFrom:(WALDataCollectionType)dataCollectionType;
+ (NSDictionary<NSString*, NSNumber*> *)dataCollectionTypeToStringMapping;
@end

@implementation WALPaymentMethodConfiguration

- (instancetype)initInternal {
    self = [super initInternal];
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
    return @[ WalleeObjectId, WalleeLinkedSpaceId, WalleeName, WalleePaymentMethod, WalleePlannedPurgeDate, WalleeResolvedDescription, WalleeResolvedImageUrl, WalleeResolvedTitle, WalleeSortOrder, WalleeSpaceId, WalleeVersion];
}

+ (NSDictionary<NSString *, Class> *)jsonComplexMapping {
    return @{WalleeDescriptionText: WALDatabaseTranslatedString.class, WalleeTitle: WALDatabaseTranslatedString.class};
}

+ (NSDictionary<NSString*,NSString*> *)jsonReMapping {
    return @{WalleeObjectId: WalleeId, WalleeDescriptionText: WalleeDescription};
}

// MARK: - Sort

+ (NSArray<NSSortDescriptor *> *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:WalleeSortOrder ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:WalleeName ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:WalleeObjectId ascending:YES]];
}

// MARK: - Enum
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
    return [[self dataCollectionTypeToStringMapping] allKeysForObject:@(dataCollectionType)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)dataCollectionTypeToStringMapping {
    return @{@"ONSITE": @(WALDataCollectionTypeOnsite), @"OFFSITE": @(WALDataCollectionTypeOffsite)};
}

// MARK: - Description
- (NSString *)description {
    NSDictionary *desc = @{
                           @"name": _name ?: NSNull.null,
                           @"objectId": @(_objectId),
                           @"spaceId": @(_linkedSpaceId),
                           @"dataCollectionType": [self.class stringFrom:_dataCollectionType],
                           @"paymentMethod": @(_paymentMethod),
                           @"title": _resolvedTitle ?: NSNull.null,
                           @"description": _resolvedDescription ?: NSNull.null,
                           @"imageUrl": _resolvedImageUrl ?: NSNull.null,
                           WalleeSortOrder: @(_sortOrder),
                           @"version": @(_version)
                           };
    return [NSString stringWithFormat:@"%@", desc];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

// MARK: - Copying
- (id)copyWithZone:(NSZone *)zone {
    WALPaymentMethodConfiguration *configuration = [[self.class allocWithZone:zone] initInternal];
    configuration->_dataCollectionType = _dataCollectionType;
//    configuration->_descriptionText = [_descriptionText copyWithZone:zone];
    configuration->_objectId = _objectId;
    configuration->_linkedSpaceId = _linkedSpaceId;
    configuration->_name = [_name copyWithZone:zone];
    configuration->_paymentMethod = _paymentMethod;
    configuration->_plannedPurgeDate = [_plannedPurgeDate copyWithZone:zone];
    configuration->_resolvedDescription = [_resolvedDescription copyWithZone:zone];
    configuration->_resolvedImageUrl = [_resolvedImageUrl copyWithZone:zone];
    configuration->_resolvedTitle = [_resolvedTitle copyWithZone:zone];
    configuration->_sortOrder = _sortOrder;
    configuration->_spaceId = _spaceId;
//    configuration->_title = [_title copyWithZone:zone];
    configuration->_version = _version;
    
    return configuration;
}

// MARK: - Equals
- (NSUInteger)hash {
    return ((_objectId << 16) + (_linkedSpaceId << 8) + (_version));
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (!object || ![object isKindOfClass:self.class]) {
        return NO;
    }
    return [self isEqualToPaymentMethodConfiguration:object];
}

- (BOOL)isEqualToPaymentMethodConfiguration:(WALPaymentMethodConfiguration *)config {
    if (self == config) {
        return YES;
    }
    return _objectId == config.objectId && _linkedSpaceId == config.linkedSpaceId && _version == config.version;
}

@end
