//
//  WALDefaultTokenListViewController.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WALTokenListViewController.h"

@interface WALDefaultTokenListViewController : UIViewController<WALTokenListViewController, UITableViewDelegate, UITableViewDataSource>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic, copy) NSArray<WALTokenVersion *> *tokens;
@property (nonatomic) WALTokenVersionSelected onTokenSelected;
NS_ASSUME_NONNULL_END
@end
