//
//  Credentials.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALCredentials.h"
#import "WALErrorDomain.h"

const NSTimeInterval WALCredentialsThreshold = 2 * 60;

@interface WALCredentials ()
@property (nonatomic, copy) NSString *credentials;
@property (nonatomic, assign) NSUInteger transactionId;
@property (nonatomic, assign) NSUInteger spaceId;
@property (nonatomic, assign) NSUInteger timestamp;
@end

@implementation WALCredentials

-(instancetype)initWithSpaceId:(NSUInteger)spaceId transactionId:(NSUInteger)transactionId timestamp:(NSUInteger)timestamp{
    if (timestamp == 0) {
        return nil;
    }
    if (self = [super init]) {
        _spaceId = spaceId;
        _transactionId = transactionId;
        _timestamp = timestamp;
    }
    return self;
}

-(instancetype)init {
    NSAssert(false,@"unavailable, use credentialsWithCredentials: instead");
    return nil;
}


+(instancetype)credentialsWithCredentials:(NSString *)credentials error:(NSError * _Nullable __autoreleasing *)error {
    
    NSArray<NSString*> *components = [self parseCredentialString:credentials error:error];
    if (!components) {
        return nil;
    }
    NSUInteger spaceId = [components[0] integerValue];
    NSUInteger transactionId = [components[1] integerValue];
    NSUInteger timestamp = [components[2] integerValue];

    WALCredentials *newCredentials = [[self alloc] initWithSpaceId:spaceId transactionId:transactionId timestamp:timestamp];
    newCredentials.credentials = credentials;
    return newCredentials;
}

-(BOOL)checkCredentials:(WALCredentials *)other error:(NSError * _Nullable __autoreleasing *)error {
    BOOL success = YES;
    if (self.transactionId != other.transactionId) {
        success = NO;
        [WALErrorHelper populate:error withIllegalStateWithMessage:@"The provided credentials do not have the same transaction transactionId."];
    } else if(self.spaceId != other.spaceId) {
        success = NO;
        [WALErrorHelper populate:error withIllegalStateWithMessage:@"The provided credentials do not have the same space transactionId."];
    }
    return success;
}

-(BOOL)isValid {
    NSTimeInterval current = [[NSDate date] timeIntervalSince1970] + WALCredentialsThreshold;
    return self.timestamp > current;
}

+(NSArray<NSString *> *)parseCredentialString:(NSString *)credentials error:(NSError * _Nullable __autoreleasing *)error {
    if (credentials.length == 0) {
        [WALErrorHelper populate:error withInvalidCredentialsWithMessage:@"The credentials are required to create a new credentials object."];
        return nil;
    }
    NSArray<NSString*> *components = [[credentials stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"-"];
    
    if (components.count < 3 || components[0].length == 0 || components[1].length == 0 || components[2].length == 0) {
        [WALErrorHelper populate:error withInvalidCredentialsWithMessage:@"Wrong credentials format."];
        return nil;
    }
    
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    __block NSError *blockError = nil;
    [components enumerateObjectsUsingBlock:^(NSString * _Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 3) { // validate only first 3 parameters
            if ([component rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
                [WALErrorHelper populate:&blockError withInvalidCredentialsWithMessage:@"Credential parameters need to be in numeric format."];
                *stop = YES;
            }
            if ([component integerValue] < 0) {
                [WALErrorHelper populate:&blockError withInvalidCredentialsWithMessage:@"Credential parameters can not be negative."];
                *stop = YES;
            }
        }
    }];
    if (blockError) {
        *error = blockError;
        return nil;
    }
    
    return components;
}
@end
