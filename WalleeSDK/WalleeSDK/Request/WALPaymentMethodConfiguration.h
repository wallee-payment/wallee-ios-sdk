//
//  PaymentMethodConfiguration.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"
@class WALDatabaseTranslatedString;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, WALDataCollectionType) {
    WALDataCollectionTypeOnsite,
    WALDataCollectionTypeOffsite,
    WALDataCollectionTypeUnknown
};
NS_ASSUME_NONNULL_END

@interface WALPaymentMethodConfiguration : NSObject<WALJSONDecodable, WALJSONAutoDecodable>
#include "WALAPIDataType.h"
NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, readonly) WALDataCollectionType dataCollectionType;
@property (nonatomic, readonly, copy) WALDatabaseTranslatedString *descriptionText;
@property (nonatomic, readonly) NSUInteger id;
//@property (nonatomic, readonly) ImageResourcePath imageResourcePath;
@property (nonatomic, readonly) NSUInteger linkedSpaceId;
@property (nonatomic, readonly, copy) NSString *name;
//@property (nonatomic, readonly) OneClickPaymentMode oneClickPaymentMode;
@property (nonatomic, readonly) NSUInteger paymentMethod;
@property (nonatomic, readonly, copy) NSString *plannedPurgeDate;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *resolvedDescription;
@property (nonatomic, readonly, copy) NSString *resolvedImageUrl;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *resolvedTitle;
@property (nonatomic, readonly) NSInteger sortOrder;
@property (nonatomic, readonly) NSUInteger spaceId;
@property (nonatomic, readonly, copy) WALDatabaseTranslatedString *title;
@property (nonatomic, readonly) NSInteger version;
NS_ASSUME_NONNULL_END
@end
