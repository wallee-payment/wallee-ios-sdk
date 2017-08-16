//
//  WALSessionApiClient.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALSessionApiClient.h"
#import "WALApiConfig.h"

@interface WALSessionApiClient ()
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong, readwrite) NSURLSession *urlSession;
@end

@implementation WALSessionApiClient

-(instancetype)initWithBaseUrl:(NSString*) baseUrl {
    if (self = [super init]) {
        _baseURL = [NSURL URLWithString:baseUrl];
        _urlSession = [NSURLSession sessionWithConfiguration:[self configuration]];
    }
    return self;
}

-(NSURLSessionConfiguration *)configuration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}

+(instancetype)clientWithBaseUrl:(NSString *)baseUrl {
    // validation
    return [[self alloc] initWithBaseUrl:baseUrl];
}


// mark: extract

-(void) buildMobileSdkUrl {
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
