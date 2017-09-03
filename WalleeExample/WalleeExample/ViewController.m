//
//  ViewController.m
//  WalleeExample
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "ViewController.h"
//#import <WalleSDK/WALFlowCoordinator.h>
@import WalleeSDK;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapPayment:(id)sender {
    NSError *error;
    WALFlowConfiguration *configuration = [WALFlowConfiguration makeWithBlock:^(WALFlowConfigurationBuilder * _Nonnull builder) {
        builder.webServiceApiClient = nil;
    } error:&error];
    
    WALFlowCoordinator *coordinator = [WALFlowCoordinator paymentFlowWithConfiguration:configuration];
    [coordinator start];
    
    [self presentViewController:coordinator.paymentContainer animated:YES completion:^{
        NSLog(@"completed");
    }];
}
@end
