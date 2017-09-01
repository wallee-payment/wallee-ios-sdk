//
//  WALApiClientError.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALApiClientError.h"
#import "WALJSONParser.h"
#import "WALApiConfig.h"

@interface WALApiClientError ()
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *defaultMessage;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *message;
@property (nonatomic) WALClientErrorType type;
@end

@implementation WALApiClientError
- (instancetype)initInternal {
    return [super init];
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALApiClientError *clientError = [[self.class alloc] initInternal];
    if (![WALJSONParser populate:clientError withDictionary:dictionary error:error]) {
        return nil;
    }
    clientError.type = [WALApiClientError errorTypeFrom:dictionary[WalleeType]];
    return clientError;
}

// MARK: - JSON

+ (NSArray<NSString *> *)jsonMapping {
    return @[WalleeId, WalleeMessage, WalleeDate, WalleeDefaultMessage];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return nil;
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{WalleeDate: _date, WalleeId: _id, WalleeMessage: _message}];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

// MARK: - Category Enum

+ (WALClientErrorType)errorTypeFrom:(NSString *)name {
    NSNumber *rawDataType = [self errorTypeToStringMapping][name.uppercaseString];
    if (rawDataType) {
        return (WALClientErrorType)rawDataType.integerValue;
    }
    return WALClientErrorTypeUnknown;
}

+ (NSString *)stringFrom:(WALClientErrorType)errorType {
    return [[self errorTypeToStringMapping] allKeysForObject:@(errorType)].firstObject;
}

+ (NSDictionary<NSString *,NSNumber *> *)errorTypeToStringMapping {
    return @{@"END_USER_ERROR": @(WALClientErrorTypeEndUserError),
             @"CONFIGURATION_ERROR": @(WALClientErrorTypeConfigurationError),
             @"DEVELOPER_ERROR": @(WALClientErrorTypeDeveloperError)};
}
@end
