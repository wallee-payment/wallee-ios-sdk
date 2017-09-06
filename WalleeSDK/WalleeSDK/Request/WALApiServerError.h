//
//  WALApiServerError.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"

@interface WALApiServerError : NSError<WALJSONDecodable, WALJSONAutoDecodable>
//#include "WALAPIDataType.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSString *objectId;
@property (nonatomic, copy, readonly) NSString *message;
NS_ASSUME_NONNULL_END
@end
