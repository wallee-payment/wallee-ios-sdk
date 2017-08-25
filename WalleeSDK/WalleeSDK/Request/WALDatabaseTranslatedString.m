//
//  DatabaseTranslatedString.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDatabaseTranslatedString.h"
#import "WALDatabaseTranslatedStringItem.h"
#import "WALErrorDomain.h"

@interface WALDatabaseTranslatedString ()
//@property (nonatomic, copy, readwrite) NSDictionary<NSString*,id> *allJSONFields;
@end

@implementation WALDatabaseTranslatedString
- (instancetype)initWithAvailableLanguages:(NSArray<NSString *> *)availableLanguages displayName:(NSString *)displayName items:(NSArray<WALDatabaseTranslatedStringItem *> *)items {
    self = [super init];
    if (self) {
        _availableLanguages = availableLanguages;
        _displayName = displayName;
        _items = items;
    }
    return self;
}

+ (instancetype) decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing * _Nullable)error{
    NSMutableArray<WALDatabaseTranslatedStringItem *> *items = nil;
    NSArray<NSDictionary*> *itemsArray = dictionary[@"items"];
    __block NSError *internalError;
    [itemsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [items addObject:[WALDatabaseTranslatedStringItem decodedObjectFromJSON:obj error:error]];
        } else {
            [WALErrorHelper populate:&internalError withIllegalArgumentWithMessage:@"Invalide structure for DatabaseTranslatedString"];
            *stop = YES;
        }
    }];
    if (internalError) {
        if (error) {
            *error = internalError;
        }
        return nil;
    }
    WALDatabaseTranslatedString *databaseString = [[WALDatabaseTranslatedString alloc] initWithAvailableLanguages:dictionary[@"availableLanguages"] displayName:dictionary[@"displayName"] items:items];
    
    return databaseString;
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

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"availableLanguages": _availableLanguages, @"displayName": _displayName, @"items": _items}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
