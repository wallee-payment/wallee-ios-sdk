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
#import "WALToken.h"
#import "WALTransaction.h"
#import "WALApiConfig.h"
#import "WALCredentials.h"
#import "WALCredentialsProvider.h"

#import "WALErrorDomain.h"
#import "WALApiClientError.h"
#import "WALApiServerError.h"

@interface WALNSURLSessionApiClient ()
@property (nonatomic, strong, readwrite) WALCredentialsProvider *credentialsProvider;
@property (nonatomic, strong, readwrite) NSURL *baseURL;
@property (nonatomic, strong, readwrite) NSURLSession *urlSession;
@end

@implementation WALNSURLSessionApiClient

- (instancetype)initWithBaseUrl:(NSString*) baseUrl credentialsProvider:(WALCredentialsProvider *)credentialsProvider {
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

+ (instancetype)clientWithCredentialsProvider:(WALCredentialsProvider *)credentialsProvider {
    return [self clientWithBaseUrl:WalleeBaseUrl credentialsProvider:credentialsProvider];
}

+ (instancetype)clientWithBaseUrl:(NSString *)baseUrl credentialsProvider:(WALCredentialsProvider *)credentialsProvider {
    // validation
    return [[self alloc] initWithBaseUrl:baseUrl credentialsProvider:credentialsProvider];
}

// MARK: API implementation

- (void)buildMobileSdkUrl:(WALMobileSdkUrlCompletion)completion {
    WALCredentialsCallback callback = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        if (!credentials) {
            completion(nil, error);
            return;
        }
        
        NSString *endpoint = [NSString stringWithFormat:@"%@?credentials=%@", WalleeEndpointBuildMobilUrl, credentials.credentials];
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
    };
    
    [self.credentialsProvider getCredentials:callback];
}

- (void)fetchPaymentMethodConfigurations:(WALPaymentMethodConfigurationsCompletion)completion {
    WALCredentialsCallback performRequest = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        if (!credentials) {
            completion(nil, error);
            return;
        }
        
        NSURL *url = [self urlForEndpoint:WalleeEndpointFetchPossiblePaymentMethods withCredentials:credentials.credentials];
        
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
    };
    
    [self.credentialsProvider getCredentials:performRequest];
}

- (void)fetchTokenVersions:(WALTokenVersionsCompletion)completion {
    WALCredentialsCallback performRequest = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        if (!credentials) {
            completion(nil, error);
            return;
        }
        
        NSURL *url = [self urlForEndpoint:WalleeEndpointFetchTokenVersion withCredentials:credentials.credentials];
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

    };
    
    [self.credentialsProvider getCredentials:performRequest];
}

- (void)readTransaction:(WALTransactionCompletion)completion {
    WALCredentialsCallback performRequest = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        if (!credentials) {
            completion(nil, error);
            return;
        }
        
        NSURL *url = [self urlForEndpoint:WalleeEndpointReadTransaction withCredentials:credentials.credentials];
        NSURLSessionTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
            NSError *error;
            NSDictionary * json = [WALNSURLSessionApiClient jsonFromData:data response:response responseError:responseError error:&error];
            if (!json) {
                completion(nil, error);
                return;
            }
            WALTransaction *transaction = [WALTransaction decodedObjectFromJSON:json error:&error];
            if (transaction) {
                completion(transaction, nil);
            } else {
                completion(nil, error);
            }
        }];
        [task resume];

    };

    [self.credentialsProvider getCredentials:performRequest];
}

- (void)processOneClickToken:(WALToken *)token completion:(WALTransactionCompletion)completion {
    WALCredentialsCallback performRequest = ^(WALCredentials * _Nullable credentials, NSError * _Nullable error) {
        if (!credentials) {
            completion(nil, error);
            return;
        }
        
        NSURL *url = [self urlForEndpoint:WalleeEndpointPerformOneClickToken withCredentials:credentials.credentials tokenId:[NSString stringWithFormat:@"%lu", (unsigned long)token.id]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
            NSError *error;
            NSDictionary * json = [WALNSURLSessionApiClient jsonFromData:data response:response responseError:responseError error:&error];
            if (!json) {
                completion(nil, error);
                return;
            }
            WALTransaction *transaction = [WALTransaction decodedObjectFromJSON:json error:&error];
            if (transaction) {
                completion(transaction, nil);
            } else {
                completion(nil, error);
            }
            
        }];
        [task resume];
    };
    
    [self.credentialsProvider getCredentials:performRequest];
}

// MARK: -
- (NSURL *)urlForEndpoint:(NSString *)endpoint withCredentials:(NSString *)credentials {
    return [self urlForEndpoint:endpoint withCredentials:credentials tokenId:nil];
}

- (NSURL *)urlForEndpoint:(NSString *)endpoint withCredentials:(NSString *)credentials tokenId:(NSString * _Nullable )tokenId {
    NSString *urlString = [NSString stringWithFormat:@"%@?credentials=%@", endpoint, credentials];
    if (tokenId) {
        urlString = [NSString stringWithFormat:@"%@&tokenId=%@", urlString, tokenId];
    }
    return [NSURL URLWithString:urlString relativeToURL:self.baseURL];
}

+ (nullable id)jsonFromData:(NSData * _Nullable)data response:(NSURLResponse * _Nullable)response responseError:(NSError * _Nullable )responseError error:(NSError * _Nullable *)error {
    
    if (data) {
        NSError *jsonError;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&jsonError];
        if (!json) {
            if (error) {
                *error = jsonError;
            }
            return nil;
        }
        
        // status codes != 200 are not handled as errors by NSURLConnection
        if (![WALNSURLSessionApiClient shouldHandleResponseCode:response withJson:json error:&jsonError]) {
            if (error) {
                *error = jsonError;
            }
            return nil;
        }
        
        return json;
    } else {
        if (error) {
            *error = responseError;
        }
        return nil;
    }
}

+ (BOOL)shouldHandleResponseCode:(NSURLResponse *)response withJson:(NSDictionary *)json error:(NSError **)error {
    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    if (statusCode == 0 || statusCode > 399) {
        if (error) {
            //TODO: impl? Cilent vs Server Error Classes
            if (statusCode == WalleClientErrorReturnCode) {
                WALApiClientError *clientError = [WALApiClientError decodedObjectFromJSON:json error:error];
                if (clientError) {
                    *error = clientError;
                }
            } else if(statusCode == WalleServerErrorReturnCode) {
                WALApiServerError *serverError = [WALApiServerError decodedObjectFromJSON:json error:error];
                if (serverError) {
                    *error = serverError;
                }
            } else {
                *error = [NSError errorWithDomain:WALErrorDomain code:WALErrorHTTPError userInfo:@{@"statusCode": @(statusCode), @"response": response, @"data": json}];
            }
        }
        return NO;
    }
    return YES;
}

@end
