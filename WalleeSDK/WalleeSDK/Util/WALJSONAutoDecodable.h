//
//  WALJSONAutoDecodable.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 25.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WALJSONAutoDecodable <NSObject>
/// all known fields with remapped names
+ (NSArray<NSString *> * _Nullable)jsonMapping;
/// mapping for non Foundation Objects
+ (NSDictionary<NSString *, Class>  * _Nullable)jsonComplexMapping;
/// names to remap
+ (NSDictionary<NSString *,NSString *> * _Nullable)jsonReMapping;
@end
