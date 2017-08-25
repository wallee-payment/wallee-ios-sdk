//
//  WALJSONParser.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 25.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONAutoDecodable.h"

@interface WALJSONParser : NSObject
+ (BOOL)populate:(NSObject<WALJSONAutoDecodable> *)object withDictionary:(NSDictionary *)dictionary error:(NSError **)error;
@end
