//
//  WALDefaultCancelViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.11.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultCancelViewController.h"
#import "WALTransaction.h"
#import "WALTranslation.h"

@interface WALDefaultCancelViewController ()

@end

@implementation WALDefaultCancelViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = WALLocalizedString(@"transaction_canceled_preamble", @"message preamble for a canceled transaction");
    self.stateLabel.text = [NSString stringWithFormat:@"%@\n %@", str, _transaction.userFailureMessage];
}

@end
