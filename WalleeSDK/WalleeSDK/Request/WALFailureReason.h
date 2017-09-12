//
//  WALFailureReason.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"
#import "WALDataObject.h"

typedef NS_ENUM(NSInteger, WALFailureCategory) {
    WALFailureCategoryTemporaryIssue,
    WALFailureCategoryInternal,
    WALFailureCategoryEndUser,
    WALFailureCategoryConfiguration,
    WALFailureCategoryDeveloper,
    WALFailureCategoryUnknown
};

// TODO: make this non initializable?
@interface WALFailureReason : WALDataObject<NSCopying, WALJSONDecodable, WALJSONAutoDecodable>

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly) WALFailureCategory category;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *descriptionText;
@property (nonatomic, readonly, copy) NSArray<NSNumber *> *features;
@property (nonatomic, readonly) NSUInteger objectId;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> *name;
NS_ASSUME_NONNULL_END
@end
