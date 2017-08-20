//
//  WALDatabaseTranslatedStringItem.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"

NS_ASSUME_NONNULL_BEGIN
@interface WALDatabaseTranslatedStringItem : NSObject<WALJSONDecodable>
@property (nonatomic, copy, readonly) NSString *language;
@property (nonatomic, copy, readonly) NSString *languageCode;
@property (nonatomic, copy, readonly) NSString *translation;

- (instancetype)initWithLanguage:(NSString *)language languageCode:(NSString *)languageCode translation:(NSString *)translation NS_DESIGNATED_INITIALIZER;
+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary;
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
