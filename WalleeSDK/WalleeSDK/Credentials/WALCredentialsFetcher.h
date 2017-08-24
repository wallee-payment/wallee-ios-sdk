//
//  WALCredentialsFetcher.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 24.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALCredentials;

NS_ASSUME_NONNULL_BEGIN

typedef void(^WALCredentialsCallback)(WALCredentials * _Nullable credentials, NSError * _Nullable error);

@protocol WALCredentialsFetcher <NSObject>
- (void)fetchCredentials:(WALCredentialsCallback)receiver;
@end

NS_ASSUME_NONNULL_END
