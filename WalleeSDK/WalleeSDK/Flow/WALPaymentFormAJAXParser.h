//
//  WALPaymentFormAJAXParser.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol WALPaymentFormAJAXParserDelegate <NSObject>
//
//- (void)didParseInitialize;
//
//- (void)didParseHeightChange:(CGFloat)targetHeight;
//
//- (void)didParseEnlargeView;
//
//- (void)didParseValidationSuccess;
//
//- (void)didParseValidationFailure:(NSArray<NSString*> *)messages;
//
//- (void)didParseAwaitingFinalStatus:(NSUInteger)transactionId;
//
//- (void)didParseSuccess;
//
//- (void)failure;
//
//- (void)httpError:(NSError *)error;
//
//@end

typedef NS_ENUM(NSUInteger, WALPaymentFormAJAXOperationType) {
    WALPaymentFormAJAXOperationTypeInitialize,
    WALPaymentFormAJAXOperationTypeHeightChange,
    WALPaymentFormAJAXOperationTypeEnlargeView,
    WALPaymentFormAJAXOperationTypeValidationSuccess,
    WALPaymentFormAJAXOperationTypeValidationFailure,
    WALPaymentFormAJAXOperationTypeAwaitingFinalStatus,
    WALPaymentFormAJAXOperationTypeSuccess,
    WALPaymentFormAJAXOperationTypeFailure,
    WALPaymentFormAJAXOperationTypeError,
    WALPaymentFormAJAXOperationTypeUnknown
};

typedef void(^WALPaymentFormAJAXParserResult)(WALPaymentFormAJAXOperationType resultType, id _Nullable result);



@interface WALPaymentFormAJAXParser : NSObject
/**
 Parses the given URL to check if it is a AJAX call back into the app

 @param url url to parse
 @return @c YES if this URL is a callback, @c NO if the url is not recognized
 */
+ (BOOL)parseUrlString:(NSString*_Nonnull)url resultBlock:(WALPaymentFormAJAXParserResult _Nonnull )resultBlock;
@end
