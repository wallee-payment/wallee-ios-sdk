//
//  WALPaymentFormView.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WALPaymentFormDelegate;

@protocol WALPaymentFormView <NSObject>
/**
 The Delegate gets informed about all corresponding events
 */
@property (nonatomic, weak) id<WALPaymentFormDelegate> delegate;

- (void)validate;
- (void)submit;
- (BOOL)isSubmitted;
@end
