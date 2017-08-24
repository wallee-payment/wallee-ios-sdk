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
@end
