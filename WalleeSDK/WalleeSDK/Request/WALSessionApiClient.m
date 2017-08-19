//
//  WALSessionApiClient.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSessionApiClient.h"
#import "WALMobileSdkUrl.h"
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


+(instancetype)clientWithBaseUrl:(NSString *)baseUrl credentialsProvider:(WALCredentials *)credentialsProvider {
    // validation
    return [[self alloc] initWithBaseUrl:baseUrl credentialsProvider:credentialsProvider];
}

// mark: extract

-(void)buildMobileSdkUrl:(void (^)(WALMobileSdkUrl * _Nonnull))completion {
    //"transaction/buildMobileSdkUrlWithCredentials?credentials=" + parameter.getCredentials()
    NSString *endpoint = [NSString stringWithFormat:@"%@?credentials=%@", WalleeEndpointBuildMobilUrl, self.credentialsProvider.credentials];
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //TODO: nonnull data
        NSString *url = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        WALTimestamp expiryDate = [[NSDate date] timeIntervalSince1970] + WalleeMobileSdkUrlExpiryTime;
        WALMobileSdkUrl *mobileUrl = [[WALMobileSdkUrl alloc] initWithUrl:url expiryDate:expiryDate];
        completion(mobileUrl);
    }];
    
    [task resume];
}

@end
