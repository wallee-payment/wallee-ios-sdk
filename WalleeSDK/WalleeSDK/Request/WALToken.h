//
//  WALToken.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"

@interface WALToken : NSObject<WALJSONDecodable, WALJSONAutoDecodable>
#include "WALAPIDataType.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly, copy) NSString *createdOn;
@property (nonatomic, readonly, copy) NSString *customerEmailAddress;
@property (nonatomic, readonly, copy) NSString *customerId;
@property (nonatomic, readonly, assign) BOOL enabledForOneClickPayment;
@property (nonatomic, readonly, copy) NSString *externalId;
@property (nonatomic, readonly, assign) NSUInteger id;
@property (nonatomic, readonly, copy) NSString *language;
@property (nonatomic, readonly, assign) NSUInteger linkedSpaceId;
@property (nonatomic, readonly, copy) NSString *plannedPurgeDate;
@property (nonatomic, readonly, copy) NSString *state;
@property (nonatomic, readonly, copy) NSString *tokenReference;
@property (nonatomic, readonly, assign) NSUInteger version;
NS_ASSUME_NONNULL_END
@end
