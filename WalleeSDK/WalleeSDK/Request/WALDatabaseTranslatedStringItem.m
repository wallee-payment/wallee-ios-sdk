//
//  WALDatabaseTranslatedStringItem.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDatabaseTranslatedStringItem.h"

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
    return [[WALDatabaseTranslatedStringItem alloc] initWithLanguage:dictionary[@"language"] languageCode:dictionary[@"languageCode"] translation:dictionary[@"translation"]];
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"language": _language, @"languageCode": _languageCode, @"translation": _translation}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}


@end
