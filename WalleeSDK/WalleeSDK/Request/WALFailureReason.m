//
//  WALFailureReason.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFailureReason.h"
#import "WALJSONParser.h"

NSString *const WalleeCategory = @"category";
NSString *const WalleeDescriptionText = @"descriptionText";
NSString *const WalleeFeatures = @"features";
NSString *const WalleeId = @"id";
NSString *const WalleeName = @"name";

@implementation WALFailureReason
- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALFailureReason *reason = [[WALFailureReason alloc] initInternal];
    if (![WALJSONParser populate:reason withDictionary:dictionary error:error]) {
        return nil;
    }
    return reason;
}

// MARK: - JSON

+ (NSArray<NSString *> *)jsonMapping {
    return @[WalleeDescriptionText, WalleeFeatures, WalleeId, WalleeName];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return nil;
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return @{@"description": WalleeDescriptionText};
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{WalleeName: _name, WalleeId: @(_id), WalleeFeatures: _features, WalleeDescriptionText: _descriptionText, WalleeCategory: [WALFailureReason stringFrom:_category]}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

// MARK: - Category Enum
/*!
 * parses the given @c NSString into the corresponding @c WALFailureCategory.
 *
 * @param name named @c WALFailureCategory
 * @return corresponding @c WALFailureCategory or @c WALFailureCategoryUnknown if no match is found
 */
+ (WALFailureCategory)failureCategoryFrom:(NSString *)name {
    NSNumber *rawDataType = [self failureCategoryToStringMapping][name.uppercaseString];
    if (rawDataType) {
        return (WALFailureCategory)rawDataType.integerValue;
    }
    return WALFailureCategoryUnknown;
}

+ (NSString *)stringFrom:(WALFailureCategory)failureCategory {
    return [[self failureCategoryToStringMapping] allKeysForObject:@(failureCategory)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)failureCategoryToStringMapping {
    return @{@"CONFIGURATION": @(WALFailureCategoryConfiguration),
             @"TEMPORARY_ISSUE": @(WALFailureCategoryTemporaryIssue),
             @"INTERNAL": @(WALFailureCategoryInternal),
             @"END_USER": @(WALFailureCategoryEndUser),
             @"DEVELOPER": @(WALFailureCategoryDeveloper)};
}
@end
