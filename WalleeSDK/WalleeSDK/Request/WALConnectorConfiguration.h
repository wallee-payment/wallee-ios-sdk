//
//  WALConnectorConfiguration.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"
@class WALPaymentMethodConfiguration;

@interface WALConnectorConfiguration : NSObject<WALJSONDecodable, WALJSONAutoDecodable>
NS_ASSUME_NONNULL_BEGIN
//@property (nonatomic, assign, readonly) BOOL applicableForTransactionProcessing;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *conditions;
@property (nonatomic, assign, readonly) NSUInteger connector;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *enabledSpaceViews;
@property (nonatomic, assign, readonly) NSUInteger objectId;
@property (nonatomic, assign, readonly) NSUInteger linkedSpaceId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) WALPaymentMethodConfiguration *paymentMethodConfiguration;
@property (nonatomic, copy, readonly) NSString *plannedPurgeDate;
@property (nonatomic, assign, readonly) NSUInteger priority;
//@property (nonatomic, copy, readonly) WALProcessorConfiguration *processorConfiguration;
//@property (nonatomic, copy, readonly) WALCreationState *state;
@property (nonatomic, assign, readonly) NSUInteger version;
NS_ASSUME_NONNULL_END
@end
