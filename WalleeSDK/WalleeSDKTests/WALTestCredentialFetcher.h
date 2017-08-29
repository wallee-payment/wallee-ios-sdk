//
//  WALTestCredentialFetcher.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 24.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALCredentialsFetcher.h"

@interface WALTestCredentialFetcher: NSObject<WALCredentialsFetcher>
@property (nonatomic, readonly, copy) WALCredentials *credentials;
@property (nonatomic, readonly, assign) NSUInteger counter;


/**
 Initializes a @c WALTestCredentialFetcher with default test data

 @return an initialized object
 */
- (instancetype)init;

/**
 Initializes a @c WALTestCredentialFetcher with the given Credentials. does not check if credentials are valid.

 @param credentials credentials to se
 @return an initialized objec
 */
- (instancetype)initWithCredentials:(WALCredentials *)credentials NS_DESIGNATED_INITIALIZER;
@end
