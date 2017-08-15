//
//  Credentials.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 The threshold which is used to check if the credentials are still valid. The threshold
 defines the minimum time in seconds which the credentials need to be valid.
 */
FOUNDATION_EXPORT const NSTimeInterval WALCredentialsThreshold;

@interface WALCredentials : NSObject

@property (nonatomic, readonly, assign) NSUInteger transactionId;
@property (nonatomic, readonly, assign) NSUInteger spaceId;
@property (nonatomic, readonly, assign) NSUInteger timestamp;
@property (nonatomic, readonly, copy) NSString *appendum;

/**
 -

 @param credentials the credential string which should be parsed.
 @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 @return a @c Credentials constructed with the given credential string
 */
+ (instancetype)credentialsWithCredentials:(NSString*)credentials error:(NSError **)error;

-(instancetype) init __attribute__((unavailable("use the static credentialsWithCredentials:")));  

/**
 An NSString object initialized by using format as a template into which the remaining argument values are substituted according to the system locale. The returned object may be different from the original receiver.

 
 
 @param spaceId the ID of the space to which the transaction belongs to.
 @param transactionId the transaction ID for which the credentials are build for. This is the transactionid to which the credentials give access to.
 @param timestamp the timestamp (seconds since 1970-01-01) when the credentials will expire on.
 @return A Credentials Object initialized with the given ids and timestamp.
 */
//-(instancetype)initWithSpaceId:(NSUInteger)spaceId transactionId:(NSUInteger)transactionId timestamp:(NSUInteger)timestamp appendum:(NSString *)appendum NS_DESIGNATED_INITIALIZER;

/**
 
 @return @c YES when the credentials are still valid otherwise the method returns @c NO
 */
- (BOOL)isValid;

/**
 * This method checks if the provided @c other credential is a valid replacement of this
 * credentials. Means the method checks whether the @c other credentials belongs to the
 * same transaction as this.
 *
 * @param other the other credential pair which should be checked.
 * @param error If an error occurs, upon returns contains an NSError object that describes the problem. If you are not interested in possible errors, pass in NULL.
 * @return YES if @c other is a valid replacement
 */
- (BOOL)checkCredentials:(WALCredentials *)other error:(NSError**)error;
@end

NS_ASSUME_NONNULL_END
