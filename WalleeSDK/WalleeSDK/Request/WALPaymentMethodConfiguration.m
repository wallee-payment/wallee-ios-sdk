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
    // remap
    NSMutableDictionary *remapped = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [self.class.jsonReMapping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull oldKey, BOOL * _Nonnull stop) {
        remapped[key] = dictionary[oldKey];
        [remapped removeObjectForKey:oldKey];
    }];
    
    //simple map
    NSArray *values = [remapped objectsForKeys:[[self class] jsonMapping] notFoundMarker:@"not-defined"];
    [self setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:values forKeys:self.class.jsonMapping]];
    
    
    //complexmap
    __block BOOL success = YES;
    __block NSError *blockError;
    [self.class.jsonComplexMapping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(WALJSONDecodable)]) {
            NSObject *value = remapped[key];
            if (!value) {
                [WALErrorHelper populate:&blockError withIllegalArgumentWithMessage:[NSString stringWithFormat:@"Unable to parse JSON. Could not find Property: %@.%@", self.class, key]];
                success = NO;
            } else {
                success = [self.class decodeJSONValue:value withClass:obj forKey:key inObject:self error:&blockError];
            }
            if (!success) {
                *stop = YES;
            }
        } else {
            [WALErrorHelper populate:&blockError withIllegalArgumentWithMessage:[NSString stringWithFormat:@"%@ is no conforming to protocol %@ and cannot be parsed", self.class, @protocol(WALJSONDecodable)]];
            success = NO;
            *stop = YES;
        }
    }];
    if (!success) {
        *error = blockError;
    }
    return success && _id != 0 && _linkedSpaceId != 0 && _name != nil;
}

+ (BOOL)decodeJSONValue:(NSObject *)value withClass:(Class)classObject forKey:(NSString *)key inObject:(NSObject *)object error:(NSError **)error {
    __block BOOL success = YES;
    if ([value isKindOfClass:NSDictionary.class]) {
        id decodedObject = [classObject decodedObjectFromJSON:(NSDictionary *)value error:error];
        if (decodedObject) {
            [object setValue:decodedObject forKey:key];
        } else {
            success = NO;
        }
    } else if ([value isKindOfClass:NSArray.class]) {
        [((NSArray *)value) enumerateObjectsUsingBlock:^(NSObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            success = [self.class decodeJSONValue:obj withClass:classObject forKey:key inObject:object error:error];
        }];
    } else {
        if (success) {
            [WALErrorHelper populate:error withIllegalArgumentWithMessage:[NSString stringWithFormat:@"Unable to parse JSON. Expected Array or Dictionary in %@.%@. found %@", self.class, key, value.class]];
        }
        success = NO;
    }

    return success;
}

/// all known fields with remapped names
+ (NSArray<NSString*> *)jsonMapping {
    return @[ @"id", @"linkedSpaceId", @"name", @"paymentMethod", @"plannedPurgeDate", @"resolvedDescription", @"resolvedDescription", @"resolvedImageUrl",@"resolvedTitle",@"sortOrder", @"spaceId", @"version"];
}
/// mapping for non Foundation Objects
+ (NSDictionary<NSString *, Class> *)jsonComplexMapping {
    return @{@"descriptionText": WALDatabaseTranslatedString.class, @"title": WALDatabaseTranslatedString.class};
}
/// names to remap
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
