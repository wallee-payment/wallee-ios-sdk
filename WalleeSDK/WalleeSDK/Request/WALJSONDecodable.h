//
//  WALJSONInitializable.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 20.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@protocol WALJSONDecodable <NSObject>

//@property (nonatomic, copy, readonly) NSDictionary<NSString*, id> *allJSONFields;

+ (instancetype)decodedObjectFromJSON:(NSDictionary<NSString*, id> *)dictionary;
@end
NS_ASSUME_NONNULL_END
