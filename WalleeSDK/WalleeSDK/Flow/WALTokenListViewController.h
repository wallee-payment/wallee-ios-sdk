//
//  WALTokenListViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTokenVersion;

typedef void(^WALTokenVersionSelected)(WALTokenVersion *_Nonnull);

@protocol WALTokenListViewController <NSObject>
@property (nonatomic, copy) NSArray<WALTokenVersion *> * _Nonnull tokens;
@property (nonatomic) WALTokenVersionSelected _Nullable onTokenSelected;
@end
