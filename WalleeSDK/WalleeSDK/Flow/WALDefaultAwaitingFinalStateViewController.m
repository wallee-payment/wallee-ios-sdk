//
//  WALDefaultAwaitingFinalStateViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultAwaitingFinalStateViewController.h"

@interface WALDefaultAwaitingFinalStateViewController ()

@end

@implementation WALDefaultAwaitingFinalStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = [NSString stringWithFormat:@"We are awaiting a feedback from your payment.\nThis may take several minutes until we receive a final feedback."];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
