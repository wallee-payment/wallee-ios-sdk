//
//  WALTestCredentialFetcher.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 24.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTestCredentialFetcher.h"
#import "WALCredentials.h"

@implementation WALTestCredentialFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUInteger timestamp = [[NSDate date] timeIntervalSince1970] + 5 * 60;
        NSString *credentialString = [NSString stringWithFormat:@"316-16005-%@-c4LUhOqIiFrwEcNU3YAJl4_28x3_b2iQAeqJI7V6yP8-grantedUser419", @(timestamp)];
        _credentials = [WALCredentials credentialsWithCredentials:credentialString error:nil];
    }
    return self;
}

- (void)fetchCredentials:(WALCredentialsCallback)receiver {
    _counter += 1;
    receiver(self.credentials, nil);
}

@end
