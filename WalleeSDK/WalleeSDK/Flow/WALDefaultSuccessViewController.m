//
//  WALDefaultSuccessViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 02.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultSuccessViewController.h"
#import "WALTransaction.h"
#import "WALTranslation.h"

@interface WALDefaultSuccessViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation WALDefaultSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = WALLocalizedString(@"transaction_success_text", @"message on transaction succes view controller");
}

@end
