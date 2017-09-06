//
//  WALDatabaseTranslatedStringItem.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDatabaseTranslatedStringItem.h"
#import "WALJSONParser.h"

static NSString * const walLanguage = @"language";
static NSString * const walLanguageCode = @"languageCode";
static NSString * const walTranslation = @"translation";

@interface WALDatabaseTranslatedStringItem ()
@end

@implementation WALDatabaseTranslatedStringItem

- (instancetype)initWithLanguage:(NSString *)language languageCode:(NSString *)languageCode translation:(NSString *)translation {
    self = [super init];
    if (self) {
        _language = language;
        _languageCode = languageCode;
        _translation = translation;
    }
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    WALDatabaseTranslatedStringItem *item = [self.class new];
    
    if (![WALJSONParser populate:item withDictionary:dictionary error:error]) {
        return nil;
    }
    
    return item;
}

// MARK: - JSONAutoDecoding
+ (NSArray<NSString*> *)jsonMapping {
    return @[ walLanguage, walLanguageCode, walTranslation];
}
+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}
+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return nil;
}
// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{walLanguage: _language, walLanguageCode: _languageCode, walTranslation: _translation}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}


@end
