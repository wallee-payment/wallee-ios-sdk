//
//  WALPaymentFormAJAXParser.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALPaymentFormAJAXParser.h"

NSString * WalleeJSProtocol = @"https://localhost/mobile-sdk-callback/";

@implementation WALPaymentFormAJAXParser
+ (BOOL)parseUrlString:(NSString *)url resultBlock:(WALPaymentFormAJAXParserResult)resultBlock {
    NSString *callback = [self extractCallbackName:url];
    if (callback) {
        
        WALPaymentFormAJAXOperationType ajaxOperation = [self operationTypeFromString:callback];
        NSDictionary* data = [self extractData:url];
        
        if (ajaxOperation == WALPaymentFormAJAXOperationTypeValidationSuccess) {
            // we need to look at the data to terminate succss from failure
            NSNumber *success = data[@"success"];
            if (![success boolValue]) {
                data = data[@"errors"];
                ajaxOperation = WALPaymentFormAJAXOperationTypeValidationFailure;
            }
        }
        
        resultBlock(ajaxOperation, data);
        return YES;
    } else {
        resultBlock(WALPaymentFormAJAXOperationTypeUnknown, nil);
        return NO;
    }
}

+ (WALPaymentFormAJAXOperationType)operationTypeFromString:(NSString *)string{
    if ([string isEqualToString:@"initializeCallback"]) {
        return WALPaymentFormAJAXOperationTypeInitialize;
    } else if ([string isEqualToString:@"heightChangeCallback"]) {
        return WALPaymentFormAJAXOperationTypeHeightChange;
    } else if ([string isEqualToString:@"validationCallback"]) {
        return WALPaymentFormAJAXOperationTypeValidationSuccess;
    } else if ([string isEqualToString:@"awaitingFinalResultCallback"]) {
        return WALPaymentFormAJAXOperationTypeAwaitingFinalStatus;
    } else if ([string isEqualToString:@"successCallback"]) {
        return WALPaymentFormAJAXOperationTypeSuccess;
    } else if ([string isEqualToString:@"failureCallback"]) {
        return WALPaymentFormAJAXOperationTypeFailure;
    }
    
    return WALPaymentFormAJAXOperationTypeUnknown;
}

+ (NSString *)extractCallbackName:(NSString *)url {
    if (![url hasPrefix:WalleeJSProtocol]) {
        return nil;
    }
    NSString *callbackPart = [url substringFromIndex:WalleeJSProtocol.length];
    NSRange range = [callbackPart rangeOfString:@"?"];
    
    return range.location == NSNotFound ? callbackPart : [callbackPart substringToIndex:range.location];
}

+ (NSDictionary<NSString *, NSString *> *)extractData:(NSString *)url {
    if (![url hasPrefix:WalleeJSProtocol]) {
        return nil;
    }
    NSRange range = [url rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    // returned url is not a valid url and as such we cannot just use NSURLComponents or NSURL
    NSString *queryString = [url substringFromIndex:range.location];
    NSString *pattern = @"data=([^&#]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:queryString options:0 range:NSMakeRange(0, queryString.length)];
    if (!match || match.range.location == NSNotFound || match.numberOfRanges < 2) {
        return nil;
    }
    
    NSString *dataString = [queryString substringWithRange:[match rangeAtIndex:1]];
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

@end
