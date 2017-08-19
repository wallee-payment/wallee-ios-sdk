//
//  WALSessionApiClient.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSessionApiClient.h"
#import "WALApiConfig.h"
#import "WALCredentials.h"

@interface WALSessionApiClient ()
@property (nonatomic, strong, readwrite) WALCredentials *credentialsProvider;
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong, readwrite) NSURLSession *urlSession;
@end

@implementation WALSessionApiClient

-(instancetype)initWithBaseUrl:(NSString*) baseUrl credentialsProvider:(WALCredentials *)credentialsProvider {
    if (self = [super init]) {
        _baseURL = [NSURL URLWithString:baseUrl];
        _urlSession = [NSURLSession sessionWithConfiguration:[self configuration]];
        _credentialsProvider = credentialsProvider;
    }
    return self;
}

-(NSURLSessionConfiguration *)configuration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

+(instancetype)clientWithBaseUrl:(NSString *)baseUrl credentialProvider:(WALCredentials *)credentialsProvider {
    // validation
    return [[self alloc] initWithBaseUrl:baseUrl credentialsProvider:credentialsProvider];
}


// mark: extract

-(void) buildMobileSdkUrl {
    //"transaction/buildMobileSdkUrlWithCredentials?credentials=" + parameter.getCredentials()
    NSString *endpoint = [NSString stringWithFormat:@"%@?credentials=xxx-xxx-xxx", WalleeEndpointBuildMobilUrl];
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
    
    NSURLSessionTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@" ---- ");
        NSLog(@" DATA: %@", data);
        NSLog(@" response: %@", response);
        NSLog(@" error: %@", error);
    }];
    
    [task resume];
}

@end
