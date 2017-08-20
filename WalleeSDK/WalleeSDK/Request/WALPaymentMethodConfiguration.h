//
//  PaymentMethodConfiguration.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
@class WALDatabaseTranslatedString;

typedef NS_ENUM(NSInteger, WALDataCollectionType) {
    WALDataCollectionTypeOnsite,
    WALDataCollectionTypeOffsite
};

@interface WALPaymentMethodConfiguration : NSObject<WALJSONDecodable>
@property (nonatomic, readonly) WALDataCollectionType dataCollectionType;
@property (nonatomic, readonly, copy) WALDatabaseTranslatedString *description;
@property (nonatomic, readonly) NSUInteger id;
//@property (nonatomic, readonly) ImageResourcePath imageResourcePath;
@property (nonatomic, readonly) NSUInteger linkedSpaceId;
@property (nonatomic, readonly) NSString *name;
//@property (nonatomic, readonly) OneClickPaymentMode oneClickPaymentMode;
@property (nonatomic, readonly) NSUInteger paymentMethod;
@property (nonatomic, readonly) NSString *plannedPurgeDate;
//@property (nonatomic, readonly) Map<String, String> resolvedDescription = new HashMap<>();
@property (nonatomic, readonly) NSString *resolvedImageUrl;
//@property (nonatomic, readonly) Map<String, String> resolvedTitle = new HashMap<>();
@property (nonatomic, readonly) NSInteger sortOrder;
@property (nonatomic, readonly) NSUInteger spaceId;
@property (nonatomic, readonly) WALDatabaseTranslatedString *title;
@property (nonatomic, readonly) NSInteger version;

- (instancetype)init NS_UNAVAILABLE;

@end
