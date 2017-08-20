//
//  DatabaseTranslatedString.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDatabaseTranslatedString.h"
#import "WALDatabaseTranslatedStringItem.h"

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

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary {
    NSMutableArray<WALDatabaseTranslatedStringItem *> *items = nil;
    NSArray<NSDictionary*> *itemsArray = dictionary[@"items"];
    [itemsArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [items addObject:[WALDatabaseTranslatedStringItem decodedObjectFromJSON:dictionary[@"items"]]];
    }];
    WALDatabaseTranslatedString *databaseString = [[WALDatabaseTranslatedString alloc] initWithAvailableLanguages:dictionary[@"availableLanguages"] displayName:dictionary[@"displayName"] items:items];
    
    return databaseString;
}

@end
