//
//  WALDefaultCancelViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.11.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultStateBaseViewController.h"

@class WALTransaction;

@interface WALDefaultCancelViewController : WALDefaultStateBaseViewController
@property (nonatomic, copy) WALTransaction *transaction;

@end
