//
//  DatabaseTranslatedString.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDatabaseTranslatedString.h"
#import "WALDatabaseTranslatedStringItem.h"
#import "WALJSONParser.h"

@interface WALDatabaseTranslatedString ()
//@property (nonatomic, copy, readwrite) NSDictionary<NSString*,id> *allJSONFields;
@end

static NSString * const walAvailableLanguages = @"availableLanguages";
static NSString * const walDisplayName = @"displayName";
static NSString * const walItems = @"items";

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

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing * _Nullable)error{

    WALDatabaseTranslatedString *string = [self.class new];
    if (![WALJSONParser populate:string withDictionary:dictionary error:error]) {
        return nil;
    }
    return string;
}

// MARK: - JSONAutoDecoding
+ (NSArray<NSString*> *)jsonMapping {
    return @[walAvailableLanguages, walDisplayName];
}

+ (NSDictionary<NSString *, Class> *)jsonComplexMapping {
    return @{walItems: WALDatabaseTranslatedStringItem.class};
}

+ (NSDictionary<NSString*,NSString*> *)jsonReMapping {
    return @{@"descriptionText": @"description"};
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{walAvailableLanguages: _availableLanguages, walDisplayName: _displayName, walItems: _items}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
