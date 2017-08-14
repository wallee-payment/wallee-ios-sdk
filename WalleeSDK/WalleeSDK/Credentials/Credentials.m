//
//  Credentials.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "Credentials.h"
#import "WALErrorDomain.h"

const NSTimeInterval WALCredentialsThreshold = 2 * 60;

@interface Credentials ()
@property (nonatomic, copy) NSString *credentials;
@property (nonatomic, assign) NSInteger transactionId;
@property (nonatomic, assign) NSInteger spaceId;
@property (nonatomic, assign) NSInteger timestamp;
@end

@implementation Credentials

-(instancetype)initWithCredentials:(NSString *)credentials {
    
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)init {
    return [self initWithCredentials:@""];
}

+(instancetype)credentialsWithCredentials:(NSString*)credentials error:(NSError **)error {
    if (credentials.length == 0) {
        *error = [WALErrorHelper invalidCredentialsWithMessage:@"The credentials are required to create a new credentials object."];
        return nil;
    }
    NSArray<NSString*> *components = [[credentials stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"-"];
    
    if (components.count < 3 || components[0].length == 0 || components[1].length == 0 || components[2].length == 0) {
        *error = [WALErrorHelper invalidCredentialsWithMessage:@"Wrong credentials format."];
        return nil;
    }
    
    Credentials *newCredentials = [[self alloc] init];
    if (newCredentials) {
        newCredentials.spaceId = [components[0] integerValue];
        newCredentials.transactionId = [components[1] integerValue];
        if (newCredentials.spaceId < 0 || newCredentials.transactionId < 0) {
            *error = [WALErrorHelper invalidCredentialsWithMessage:@"IDs can not be negative."];
            return nil;
        }
        newCredentials.timestamp = [components[2] integerValue];
        if (newCredentials.timestamp < 0) {
            *error = [WALErrorHelper invalidCredentialsWithMessage:@"Timestamps can not be negative."];
            return nil;
        }
        newCredentials.credentials = [credentials stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return newCredentials;
}

-(BOOL)isValid {
//    NSTimeInterval elapsed =
    return true;
}

-(NSArray *)parseCredentialString:(NSString *)credentials error:(NSError **)error {
    if (credentials.length == 0) {
        *error = [WALErrorHelper invalidCredentialsWithMessage:@"The credentials are required to create a new credentials object."];
        return nil;
    }
    NSArray<NSString*> *components = [[credentials stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsSeparatedByString:@"-"];
    
    if (components.count < 3 || components[0].length == 0 || components[1].length == 0 || components[2].length == 0) {
        *error = [WALErrorHelper invalidCredentialsWithMessage:@"Wrong credentials format."];
        return nil;
    }
    
    
    
    return components;
}
@end
