//
//  WALSuccessViewControllerFactory.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WALTransaction, UIViewController;

@protocol WALSuccessViewControllerFactory <NSObject>
- (UIViewController *_Nonnull)buildWithTransaction:(WALTransaction * _Nonnull)transaction;
@end
