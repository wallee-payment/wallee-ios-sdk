//
//  WALApiServerError.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALApiServerError.h"
#import "WALJSONParser.h"
#import "WALApiConfig.h"

@implementation WALApiServerError

- (instancetype)initInternal {
    return [super init];
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALApiServerError *serverError = [[self.class alloc] initInternal];
    if (![WALJSONParser populate:serverError withDictionary:dictionary error:error]) {
        return nil;
    }
    return serverError;
}

// MARK: - JSON

+ (NSArray<NSString *> *)jsonMapping {
    return @[WalleeId, WalleeMessage, WalleeDate];
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
@end
