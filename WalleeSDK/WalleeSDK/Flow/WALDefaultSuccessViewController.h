//
//  WALDefaultSuccessViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultStateBaseViewController.h"
@class WALTransaction;

@interface WALDefaultSuccessViewController : WALDefaultStateBaseViewController
@property (nonatomic, copy) WALTransaction *transaction;
@end
