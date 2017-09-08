//
//  WALPaymentMethodIcon.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentMethodIcon.h"

@interface WALPaymentMethodIcon ()
@property (nonatomic, copy, readwrite) NSString *mimeType;
@property (nonatomic, copy, readwrite) NSData *data;
@property (nonatomic, copy, readwrite) NSString *url;
@end

@implementation WALPaymentMethodIcon

- (instancetype)initWithUrl:(NSString *)url mimeType:(NSString *)mimeType base64Data:(NSData *)data {
    if (self = [super init]) {
        _mimeType = mimeType.copy;
        _url = url.copy;
        _data = data.copy;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    WALPaymentMethodIcon *icon = [[self.class allocWithZone:zone] initWithUrl:self.url
                                                                     mimeType:self.mimeType
                                                                   base64Data:self.data];
    return icon;
}

// MARK: - Description
- (NSString *)description {
    NSDictionary *desc = @{
                           @"url": _url ?: NSNull.null,
                           @"mimeType": _mimeType ?: NSNull.null,
                           @"data": _data ?: NSNull.null
                           };
    return [NSString stringWithFormat:@"%@", desc];
}

- (NSString *)debugDescription{
    return [NSString stringWithFormat:@"<%@: %p, \"%@\">", [self class], self, [self description]];
}

@end
