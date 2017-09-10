//
//  WALDefaultFailureViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALDefaultBaseViewController.h"

@class WALTransaction;

@interface WALDefaultFailureViewController : WALDefaultBaseViewController
@property (nonatomic, copy) WALTransaction *transaction;
@end
