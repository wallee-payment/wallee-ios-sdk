//
//  WALToken.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenVersion.h"
#import "WALDataObject+Private.h"
#import "WALJSONParser.h"
#import "WALToken.h"
#import "WALConnectorConfiguration.h"
#import "WALApiConfig.h"


@implementation WALTokenVersion

- (instancetype)initInternal {
    self = [super initInternal];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALTokenVersion *tokenVersion = [[WALTokenVersion alloc] initInternal];
    if (![WALJSONParser populate:tokenVersion withDictionary:dictionary error:error]) {
        return nil;
    }
    return tokenVersion;
}

// MARK: - JSON
+(NSArray<NSString *> *)jsonMapping {
    return @[WalleeActivatedOn, WalleeCreatedOn, WalleeObjectId, WalleeLanguage, WalleeLinkedSpaceId, WalleeName, WalleeObsoletedOn, WalleePlannedPurgeDate, WalleeProcessorToken, WalleeVersion];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return @{WalleeToken: WALToken.class, WalleePaymentConnectorConfiguration: WALConnectorConfiguration.class};
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return @{WalleeObjectId: WalleeId};
}

// MARK: - Sort
+ (NSArray<NSSortDescriptor *> *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:WalleeName ascending:YES],
             [NSSortDescriptor sortDescriptorWithKey:WalleeObjectId ascending:YES]];
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{
                                               WalleeLinkedSpaceId: @(_linkedSpaceId),
                                               WalleeObjectId: @(_objectId),
                                               WalleeName: _name ?: NSNull.null,
                                               WalleeCreatedOn: _createdOn ?: NSNull.null,
                                               WalleeActivatedOn: _activatedOn ?: NSNull.null,
                                               WalleeObsoletedOn: _obsoletedOn ?: NSNull.null,
                                               WalleeLanguage: _language ?: NSNull.null,
                                               WalleePaymentConnectorConfiguration: _paymentConnectorConfiguration ?: NSNull.null,
                                               WalleePlannedPurgeDate: _plannedPurgeDate ?: NSNull.null,
                                               WalleeProcessorToken: _processorToken ?: NSNull.null,
                                               WalleeToken: _token ?: NSNull.null,
                                               WalleeVersion: @(_version)
                                               }];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}
@end
