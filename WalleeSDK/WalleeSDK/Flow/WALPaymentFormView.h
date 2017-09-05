//
//  WALPaymentFormView.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WALPaymentFormView <NSObject>
- (void)validate;
- (void)submit;
- (BOOL)isSubmitted;
@end
