//
//  WALApiClientError.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALJSONDecodable.h"
#import "WALJSONAutoDecodable.h"

typedef NS_ENUM(NSUInteger, WALClientErrorType) {
    WALClientErrorTypeEndUserError,
    WALClientErrorTypeConfigurationError,
    WALClientErrorTypeDeveloperError,
    WALClientErrorTypeUnknown
};

@interface WALApiClientError : NSError<WALJSONDecodable, WALJSONAutoDecodable>
//#include "WALAPIDataType.h"
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSString *defaultMessage;
@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, readonly) WALClientErrorType type;
NS_ASSUME_NONNULL_END
@end
