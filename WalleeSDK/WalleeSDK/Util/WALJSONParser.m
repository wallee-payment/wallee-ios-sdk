//
//  WALJSONParser.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 25.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALJSONParser.h"
#import "WALErrorDomain.h"
#import "WALJSONDecodable.h"

static NSString * const UndefinedMapping = @"not-defined";

@implementation WALJSONParser
+ (BOOL)populate:(NSObject<WALJSONAutoDecodable> *)object withDictionary:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error {
    // guard
    BOOL isDictionary = [WALErrorHelper checkDictionaryType:dictionary withMessage:[NSString stringWithFormat:@"%@ json response is not a NSDictionary", object.class] error:error];
    if (!isDictionary) {
        return NO;
    }
    
    // remap
    NSMutableDictionary *remapped = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    [[object.class jsonReMapping] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull oldKey, BOOL * _Nonnull stop) {
        remapped[key] = dictionary[oldKey];
        [remapped removeObjectForKey:oldKey];
    }];
    
    //simple map
    NSArray *keys = [object.class jsonMapping];
    NSArray *values = [remapped objectsForKeys:keys notFoundMarker:UndefinedMapping];
    NSMutableArray *sanitizedValues = [[NSMutableArray alloc] initWithCapacity:values.count];
    NSMutableArray *sanitizedKeyes = [[NSMutableArray alloc] initWithCapacity:keys.count];
    [values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != NSNull.null && ![obj isEqual:UndefinedMapping]) {
            [sanitizedValues addObject:obj];
            [sanitizedKeyes addObject:keys[idx]];
        }
    }];
    
    [object setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects:sanitizedValues forKeys:sanitizedKeyes]];
    
    
    //complexmap
    __block BOOL success = YES;
    __block NSError *blockError;
    [[object.class jsonComplexMapping ] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull classObject, BOOL * _Nonnull stop) {
        if ([classObject conformsToProtocol:@protocol(WALJSONDecodable)]) {
            NSObject *value = remapped[key];
            if (!value) {
                // fields are optional and as such we don't throw errors
//                [WALErrorHelper populate:&blockError withIllegalArgumentWithMessage:[NSString stringWithFormat:@"Unable to parse JSON. Could not find Property: %@.%@", object.class, key]];
//                success = NO;
            } else {
                success = [self.class decodeJSONValue:value withClass:classObject forKey:key inObject:object error:&blockError];
            }
            if (!success) {
                *stop = YES;
            }
        } else {
            [WALErrorHelper populate:&blockError withIllegalArgumentWithMessage:[NSString stringWithFormat:@"%@ is no conforming to protocol %@ and cannot be parsed", object.class, @protocol(WALJSONDecodable)]];
            success = NO;
            *stop = YES;
        }
    }];
    if (!success) {
        *error = blockError;
    }
    return success;
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
    } else if (value == NSNull.null) {
        // fields are optional as such we don't throw errors
    } else {
        if (success) {
            [WALErrorHelper populate:error withIllegalArgumentWithMessage:[NSString stringWithFormat:@"Unable to parse JSON. Expected Array or Dictionary in %@.%@. found %@", object.class, key, value.class]];
        }
        success = NO;
    }
    
    return success;
}

@end
