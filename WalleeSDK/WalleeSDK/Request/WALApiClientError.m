//
//  WALApiClientError.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALApiClientError.h"
#import "WALErrorDomain.h"
#import "WALJSONParser.h"
#import "WALApiConfig.h"

@interface WALApiClientError ()
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *defaultMessage;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *message;
@property (nonatomic) WALClientErrorType type;
@end

@implementation WALApiClientError

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    
    NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    mutable[NSLocalizedDescriptionKey] = dictionary[WalleeMessage] ?: dictionary[WalleeDefaultMessage] ?: NSNull.null;
    
    WALApiClientError *clientError = [self.class errorWithDomain:WALErrorDomain code:WALErrorTransactionFailure userInfo:mutable];
    if (![WALJSONParser populate:clientError withDictionary:mutable error:error]) {
        return nil;
    }
    clientError.type = [WALApiClientError errorTypeFrom:mutable[WalleeType]];
    return clientError;
}

// MARK: - Accessors

// MARK: - JSON
+ (NSArray<NSString *> *)jsonMapping {
    return @[WalleeId, WalleeMessage, WalleeDate, WalleeDefaultMessage];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return nil;
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return @{WalleeObjectId: WalleeId};
}

// MARK: - Description
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{WalleeDate: _date ?: NSNull.null, WalleeObjectId: _objectId ?: NSNull.null, WalleeMessage: _message ?: NSNull.null, WalleeDefaultMessage: _defaultMessage ?: NSNull.null}];
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
