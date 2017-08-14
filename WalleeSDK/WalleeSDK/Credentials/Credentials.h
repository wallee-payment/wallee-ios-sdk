//
//  Credentials.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern const NSTimeInterval WALCredentialsThreshold;

@interface Credentials : NSObject

@property (nonatomic, readonly, copy) NSString *credentials;
@property (nonatomic, readonly, assign) NSInteger transactionId;
@property (nonatomic, readonly, assign) NSInteger spaceId;
@property (nonatomic, readonly, assign) NSInteger timestamp;

- (instancetype) initWithCredentials:(NSString *)credentials NS_DESIGNATED_INITIALIZER;

- (BOOL)isValid;
- (void)checkCredentials:(Credentials *)otherCredentials;
@end

NS_ASSUME_NONNULL_END
