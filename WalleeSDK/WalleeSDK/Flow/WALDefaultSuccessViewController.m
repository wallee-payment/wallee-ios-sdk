//
//  WALDefaultSuccessViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultSuccessViewController.h"
#import "WALTransaction.h"

@interface WALDefaultSuccessViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation WALDefaultSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.label = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.label.text = @"Transaction Successfull";
    [self.view addSubview:self.label];
}

@end
