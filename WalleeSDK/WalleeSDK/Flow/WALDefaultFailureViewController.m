//
//  WALDefaultFailureViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultFailureViewController.h"
#import "WALTransaction.h"
#import "WALTranslation.h"

@interface WALDefaultFailureViewController ()

@end

@implementation WALDefaultFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = WALLocalizedString(@"Transaction Failed:", @"message preamble for a failed transaction");
    self.stateLabel.text = [NSString stringWithFormat:@"%@\n %@", str, _transaction.userFailureMessage];
}

@end
