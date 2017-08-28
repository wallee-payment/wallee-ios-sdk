//
//  WALFailureReason.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALFailureReason.h"
#import "WALJSONParser.h"

@implementation WALFailureReason
- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    WALFailureReason *reason = [[WALFailureReason alloc] initInternal];
    if (![WALJSONParser populate:reason withDictionary:dictionary error:error]) {
        return nil;
    }
    return reason;
}

// MARK: - JSON

+ (NSArray<NSString *> *)jsonMapping {
    return nil;
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return nil;
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}

@end
