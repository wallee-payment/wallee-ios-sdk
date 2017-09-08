//
//  WALNSURLIconLoader.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALNSURLIconLoader.h"
#import "WALApiConfig.h"
#import "WALNSURLSessionHelper.h"
#import "WALErrorDomain.h"

#import "WALPaymentMethodConfiguration.h"
#import "WALPaymentMethodIcon.h"

@interface WALNSURLIconLoader ()
@property (nonatomic, strong, readwrite) NSURLSession *urlSession;
@end

@implementation WALNSURLIconLoader

- (instancetype)initWithOperationQueue:(NSOperationQueue *)queue {
    if (self = [super init]) {
        _urlSession = [NSURLSession sessionWithConfiguration:self.configuration delegate:nil delegateQueue:queue];
    }
    return self;
}

- (NSURLSessionConfiguration *)configuration {
    return [NSURLSessionConfiguration ephemeralSessionConfiguration];
}

+ (instancetype)iconLoaderWithOperationQueue:(NSOperationQueue *)queue {
    return [[self alloc] initWithOperationQueue:queue];
}

// load single
- (void)fetchIcon:(WALPaymentMethodConfiguration *)paymentMethodConfiguration completion:(WALPaymentIconCompletion)completion {
    
    NSString *urlString = paymentMethodConfiguration.resolvedImageUrl;
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSError *error;
        [WALErrorHelper populate:&error withIllegalArgumentWithMessage:[NSString stringWithFormat:@"Icon URL of Payment Method is not valid: %@", urlString]];
        completion(nil, nil, error);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable responseError) {
        if (!data) {
            completion(nil, nil, responseError);
            return;
        }
        NSError *error;
        if (![WALNSURLSessionHelper shouldHandleResponseCode:response]) {
//            [WALNSURLSessionHelper jsonFromData:data response:response responseError:responseError error:&error];

            [WALErrorHelper populate:&error withIllegalArgumentWithMessage:@"PaymentConfiguration Image URL returned invalide responseCode"];
            completion(nil, nil, error);
            return;
        }
        
        NSString *mimeType = [WALNSURLSessionHelper extractMimeType:response];
        if (!mimeType) {
            [WALErrorHelper populate:&error withIllegalArgumentWithMessage:@"PaymentConfiguration Image has no Content-Type"];
            completion(nil, nil, error);
            return;
        }
        
        WALPaymentMethodIcon *paymentIcon = [[WALPaymentMethodIcon alloc] initWithUrl:response.URL.absoluteString mimeType:mimeType base64Data:data];
        completion(paymentMethodConfiguration, paymentIcon, nil);
    }];
    [task resume];
}

//- (void)fetchIcon:(NSString)
// fetch list

@end
