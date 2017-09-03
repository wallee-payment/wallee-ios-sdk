//
//  WALCredentialsProvider.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 24.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALCredentialsProvider.h"
#import "WALCredentialsFetcher.h"
#import "WALCredentials.h"
#import "WALErrorDomain.h"

@interface WALCredentialsProvider ()
@property (nonatomic, strong) id<WALCredentialsFetcher> credentialsFetcher;
@property (nonatomic, copy) WALCredentials *currentCredentials;
@property (nonatomic, strong) dispatch_queue_t credentialQueue;
@end

@implementation WALCredentialsProvider

- (instancetype)initWith:(id<WALCredentialsFetcher>)credentialsFetcher {
    self = [super init];
    if (self) {
        _credentialsFetcher = credentialsFetcher;
        _credentialQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    }
    return self;
}

- (void)getCredentials:(WALCredentialsCallback)callback {
    dispatch_sync(self.credentialQueue, ^{
        if (!self.currentCredentials || !self.currentCredentials.isValid) {
            [self.credentialsFetcher fetchCredentials:^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
                
                dispatch_barrier_async(self.credentialQueue, ^{
                    [self processCredentials:credentials error:error callback:callback];
                });
                
            }];
        } else {
            callback(self.currentCredentials, nil);
        }
    });
}

// MARK: - Internal

- (void)processCredentials:(WALCredentials *)credentials error:(NSError *)error callback:(WALCredentialsCallback)callback {
    NSError *internalError;
    if (!credentials) {
        if (error) {
            callback(nil, error);
        } else {
            // TODO: Test scope of internalError
            NSString *message = [NSString stringWithFormat:@"The fetcher %@ provides an invalid credential object. It is null.", [self.credentialsFetcher class]];
            [WALErrorHelper populate:&internalError withIllegalStateWithMessage:message];
            callback(nil, internalError);
        }
    } else if (!credentials.isValid) {
        NSString *message = [NSString stringWithFormat:@"The fetcher %@ provides an invalid credential object. It is already expired.", [self.credentialsFetcher class]];
        [WALErrorHelper populate:&internalError withIllegalStateWithMessage:message];
        callback(nil, internalError);
    } else {
        if ([self testAndSetCredentials:credentials error:&internalError]) {
            callback(self.currentCredentials, nil);
        } else {
            callback(nil, internalError);
        }
    }
}

- (BOOL)testAndSetCredentials:(WALCredentials *)credentials error:(NSError **)error {
    BOOL success = YES;
    if (self.currentCredentials) {
        if ([self.currentCredentials checkCredentials:credentials error:error]) {
            if (self.currentCredentials.timestamp < credentials.timestamp) {
                self.currentCredentials = credentials;
            }
        } else {
            success = NO;
        }
    } else {
        self.currentCredentials = credentials;
    }
    return success;
}

@end
