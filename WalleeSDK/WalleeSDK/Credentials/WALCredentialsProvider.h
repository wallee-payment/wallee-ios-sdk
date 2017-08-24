//
//  WALCredentialsProvider.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 24.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALCredentialsFetcher.h"

NS_ASSUME_NONNULL_BEGIN
@interface WALCredentialsProvider : NSObject
- (instancetype)initWith:(id<WALCredentialsFetcher>)credentialsFetcher;
- (instancetype)init NS_UNAVAILABLE;

- (void)getCredentials:(WALCredentialsCallback)callback;
@end
NS_ASSUME_NONNULL_END
