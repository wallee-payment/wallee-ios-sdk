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
@class WALConnectorConfiguration, WALToken;

@interface WALTokenVersion : NSObject<WALJSONDecodable, WALJSONAutoDecodable>
#include "WALDataMixin.h"

NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, readonly, copy) NSString *activatedOn;
//private Address billingAddress;
@property (nonatomic, readonly, copy) NSString *createdOn;
//private ChargeAttemptEnvironment environment;
@property (nonatomic, readonly, assign) NSUInteger id;
//private List<Label> labels;
@property (nonatomic, readonly, copy) NSString *language;
@property (nonatomic, readonly, assign) NSUInteger linkedSpaceId;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *obsoletedOn;
@property (nonatomic, readonly, copy) WALConnectorConfiguration *paymentConnectorConfiguration;
@property (nonatomic, readonly, copy) NSString *plannedPurgeDate;
@property (nonatomic, readonly, copy) NSString *processorToken;
//private Address shippingAddress;
//private TokenVersionState state;
@property (nonatomic, readonly, assign) NSUInteger version;
@property (nonatomic, readonly, copy) WALToken *token;
@end
NS_ASSUME_NONNULL_END
