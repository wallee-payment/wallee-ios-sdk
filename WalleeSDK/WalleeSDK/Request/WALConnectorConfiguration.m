//
//  WALConnectorConfiguration.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALConnectorConfiguration.h"
#import "WALJSONParser.h"
#import "WALApiConfig.h"
#import "WALPaymentMethodConfiguration.h"

@implementation WALConnectorConfiguration

- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    
    WALConnectorConfiguration *configuration = [[WALConnectorConfiguration alloc] initInternal];
    if (![WALJSONParser populate:configuration withDictionary:dictionary error:error]) {
        return nil;
    }
    return configuration;
}


// MARK: - JSONAutoDecoding
+ (NSArray<NSString*> *)jsonMapping {
    return @[WalleeObjectId, WalleeLinkedSpaceId, WalleeName, WalleeConditions, WalleeConnector, WalleeEnabledSpaceViews, WalleePlannedPurgeDate, WalleePriority, WalleeVersion];
}

+ (NSDictionary<NSString *, Class> *)jsonComplexMapping {
    return @{WalleePaymentMethodConfiguration: WALPaymentMethodConfiguration.class};
}

+ (NSDictionary<NSString*,NSString*> *)jsonReMapping {
    return @{WalleeObjectId: WalleeId};
}

- (NSString *)description {
    NSArray *arr = @[@(_objectId), @(_linkedSpaceId), _name ?: NSNull.null,
                     _conditions ?: NSNull.null, @(_connector), _enabledSpaceViews ?: NSNull.null,
                      _plannedPurgeDate ?: NSNull.null, @(_priority),
                     @(_version)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:arr forKeys:[self.class jsonMapping]];
    dict[WalleePaymentMethodConfiguration] = _paymentMethodConfiguration ?: NSNull.null;
    return [NSString stringWithFormat:@"%@", dict];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}
@end
