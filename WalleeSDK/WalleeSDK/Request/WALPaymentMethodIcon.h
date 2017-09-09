//
//  WALPaymentMethodIcon.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALPaymentMethodIcon : NSObject<NSCopying>
NS_ASSUME_NONNULL_BEGIN
/**
 The mime type of the received image.
 */
@property (nonatomic, copy, readonly) NSString *mimeType;
/**
 The image data as it is received from the webrequest.
 */
@property (nonatomic, copy, readonly) NSData *data;
/**
 The url from which the image data was fetched.
 */
@property (nonatomic, copy, readonly) NSString *url;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithUrl:(NSString *)url mimeType:(NSString *)mimeType base64Data:(NSData *)data;

- (NSString *)dataAsString;
NS_ASSUME_NONNULL_END
@end
