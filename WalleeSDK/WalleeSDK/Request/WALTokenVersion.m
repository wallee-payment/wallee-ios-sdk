//
//  WALToken.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 28.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTokenVersion.h"

@implementation WALTokenVersion

- (instancetype)initInternal {
    self = [super init];
    return self;
}

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString *,id> *)dictionary error:(NSError * _Nullable __autoreleasing *)error {
    return [[WALTokenVersion alloc] initInternal];
}

+(NSArray<NSString *> *)jsonMapping {
    return @[];
}

+ (NSDictionary<NSString *,Class> *)jsonComplexMapping {
    return @{};
}

+ (NSDictionary<NSString *,NSString *> *)jsonReMapping {
    return nil;
}
@end
