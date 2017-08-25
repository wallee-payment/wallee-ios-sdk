//
//  DatabaseTranslatedString.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"

NS_ASSUME_NONNULL_BEGIN

@class WALDatabaseTranslatedStringItem;

@interface WALDatabaseTranslatedString : NSObject<WALJSONDecodable, WALJSONAutoDecodable>
@property (nonatomic, copy, readonly) NSArray<NSString *> *availableLanguages;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSArray<WALDatabaseTranslatedStringItem *> *items;

- (instancetype)initWithAvailableLanguages:(NSArray<NSString *> *)availableLanguages displayName:(NSString *)displayName items:(NSArray<WALDatabaseTranslatedStringItem *> *)items NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END
