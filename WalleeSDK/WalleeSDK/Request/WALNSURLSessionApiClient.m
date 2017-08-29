//
//  WALNSURLSessionApiClient.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 15.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALNSURLSessionApiClient.h"
#import "WALMobileSdkUrl.h"
#import "WALPaymentMethodConfiguration.h"
#import "WALTokenVersion.h"
#import "WALTransaction.h"
#import "WALApiConfig.h"
#import "WALCredentials.h"
#import "WALErrorDomain.h"

@interface WALNSURLSessionApiClient ()
@property (nonatomic, strong, readwrite) WALCredentials *credentialsProvider;
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong, readwrite) NSURLSession *urlSession;
@end

@implementation WALNSURLSessionApiClient

- (instancetype)initWithBaseUrl:(NSString*) baseUrl credentialsProvider:(WALCredentials *)credentialsProvider {
    if (self = [super init]) {
        _baseURL = [NSURL URLWithString:baseUrl];
        _urlSession = [NSURLSession sessionWithConfiguration:[self configuration]];
        _credentialsProvider = credentialsProvider;
    }
    return self;
}

- (NSURLSessionConfiguration *)configuration {
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}


+ (instancetype)clientWithBaseUrl:(NSString *)baseUrl credentialsProvider:(WALCredentials *)credentialsProvider {
    // validation
    return [[self alloc] initWithBaseUrl:baseUrl credentialsProvider:credentialsProvider];
}

// MARK: API implementation

- (void)buildMobileSdkUrl:(WALMobileSdkUrlCompletion)completion {
    NSString *endpoint = [NSString stringWithFormat:@"%@?credentials=%@", WalleeEndpointBuildMobilUrl, self.credentialsProvider.credentials];
    NSURL *url = [NSURL URLWithString:endpoint relativeToURL:self.baseURL];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSString *url = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            WALTimestamp expiryDate = [[NSDate date] timeIntervalSince1970] + WalleeMobileSdkUrlExpiryTime;
            WALMobileSdkUrl *mobileUrl = [[WALMobileSdkUrl alloc] initWithUrl:url expiryDate:expiryDate];
            completion(mobileUrl, nil);
        } else {
            completion(nil, error);
        }
    }];
    
    [task resume];
}

- (void)fetchPaymentMethodConfigurations:(WALPaymentMethodConfigurationsCompletion)completion {
    NSURL *url = [self urlForEndpoint:WalleeEndpointFetchPossiblePaymentMethods withCredentials:self.credentialsProvider.credentials];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        
        NSError *error;
        NSArray * json = [WALNSURLSessionApiClient jsonFromData:data response:response responseError:responseError error:&error];
        
        if (!json || ![WALErrorHelper checkArrayType:json withMessage:@"PaymentMethodConfiguration json response is not an array" error:&error]) {
            completion(nil, error);
            return;
        }
        
        __block NSError *paymentMethodError;
        __block NSMutableArray *paymentConfigurations = [NSMutableArray arrayWithCapacity:json.count];
        [json enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WALPaymentMethodConfiguration *config = [WALPaymentMethodConfiguration decodedObjectFromJSON:dict error:&paymentMethodError];
            if (config) {
                [paymentConfigurations addObject:config];
            } else {
                paymentConfigurations = nil;
                *stop = YES;
            }
        }];
        
        if (paymentConfigurations) {
            completion(paymentConfigurations, nil);
        } else {
            completion(nil, paymentMethodError);
        }
    }];
    
    [task resume];
}

- (void)fetchTokenVersions:(WALTokenVersionsCompletion)completion {
    // TODO: !!! change credentials Provider
    NSURL *url = [self urlForEndpoint:WalleeEndpointFetchTokenVersion withCredentials:self.credentialsProvider.credentials];
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {

        NSError *error;
        NSArray * json = [WALNSURLSessionApiClient jsonFromData:data response:response responseError:responseError error:&error];
        
        if (!json || ![WALErrorHelper checkArrayType:json withMessage:@"FetchTokenVersions json response is not an array" error:&error]) {
            completion(nil, error);
            return;
        }
        
        __block NSError *tokenVersionsError;
        __block NSMutableArray *tokenVersions = [NSMutableArray arrayWithCapacity:json.count];
        [json enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
            WALTokenVersion *tokenVersion = [WALTokenVersion decodedObjectFromJSON:dict error:&tokenVersionsError];
            if (tokenVersion) {
                [tokenVersions addObject:tokenVersion];
            } else {
                tokenVersions = nil;
                *stop = YES;
            }
            
        }];
        
        if (tokenVersions) {
            completion(tokenVersions, nil);
        } else {
            completion(nil, tokenVersionsError);
        }
    }];
    
    [task resume];
}

- (void)readTransaction:(WALTransactionCompletion)completion {
    // !!!: change credentials Provider
    NSURL *url = [self urlForEndpoint:WalleeEndpointReadTransaction withCredentials:self.credentialsProvider.credentials];
    NSURLSessionTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        NSError *error;
        NSDictionary * json = [WALNSURLSessionApiClient jsonFromData:data response:response responseError:responseError error:&error];
        if (!json) {
            completion(nil, error);
        }
        WALTransaction *transaction = [WALTransaction decodedObjectFromJSON:json error:&error];
        if (transaction) {
            completion(transaction, nil);
        } else {
            completion(nil, error);
        }
    }];
    [task resume];
}



// MARK: -
- (NSURL *)urlForEndpoint:(NSString *)endpoint withCredentials:(NSString *)credentials {
    NSString *urlString = [NSString stringWithFormat:@"%@?credentials=%@", endpoint, credentials];
    return [NSURL URLWithString:urlString relativeToURL:self.baseURL];
}

+ (nullable id)jsonFromData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response responseError:(NSError * _Nullable )responseError error:(NSError * _Nullable *)error {
    
    if (data) {
        NSError *jsonError;
        NSObject* json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&jsonError];
        if (!json && error) {
            *error = jsonError;
        }
        return json;
    } else {
        if (error) {
            *error = responseError;
        }
        return nil;
    }
}

@end
