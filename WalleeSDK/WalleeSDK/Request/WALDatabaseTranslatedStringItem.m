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

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary {
    return [[WALDatabaseTranslatedStringItem alloc] initWithLanguage:dictionary[@"language"] languageCode:dictionary[@"languageCode"] translation:dictionary[@"translation"]];
}

@end
