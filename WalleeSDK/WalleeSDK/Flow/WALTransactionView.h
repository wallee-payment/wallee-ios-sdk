//
//  WALTransactionView.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTransaction;

@protocol WALTransactionView <NSObject>
@property (nonatomic, copy) WALTransaction * _Nonnull transaction;
@end
