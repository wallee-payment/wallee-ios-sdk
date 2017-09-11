//
//  WALDefaultAwaitingFinalStateViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultAwaitingFinalStateViewController.h"
#import "WALTranslation.h"

@interface WALDefaultAwaitingFinalStateViewController ()

@end

@implementation WALDefaultAwaitingFinalStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateLabel.text = WALLocalizedString(@"We are awaiting a feedback from your payment.\nThis may take several minutes until we receive a final feedback.", @"awaiting final state view controller message");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
