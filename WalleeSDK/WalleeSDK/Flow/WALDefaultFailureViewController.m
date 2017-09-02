//
//  WALDefaultFailureViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultFailureViewController.h"
#import "WALTransaction.h"

@interface WALDefaultFailureViewController ()

@end

@implementation WALDefaultFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = [NSString stringWithFormat:@"Transaction Failed: %@", _transaction.userFailureMessage];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
