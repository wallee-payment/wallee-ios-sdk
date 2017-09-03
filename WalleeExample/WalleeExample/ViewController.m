//
//  ViewController.m
//  WalleeExample
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "ViewController.h"
#import "TestCredentialsFetccher.h"

//#import <WalleSDK/WALFlowCoordinator.h>
@import WalleeSDK;

@interface ViewController ()
@property (nonatomic, strong) WALFlowCoordinator *coordinator;
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
    [self startPaymentWithBuilderSyntax];
}

- (void)startPaymentWithBuilderSyntax {
    NSError *error;
    TestCredentialsFetccher *fetcher = [[TestCredentialsFetccher alloc] init];
    WALFlowConfigurationBuilder *builder = [[WALFlowConfigurationBuilder alloc] initWithCredentialsFetcher:fetcher];
    //additional setup
    //builder.viewControllerFactory =
    
    WALFlowConfiguration *configuration = [WALFlowConfiguration makeWithBuilder:builder error:&error];
    if (!configuration) {
        [self displayError:error];
        return;
    }
    
    self.coordinator = [WALFlowCoordinator paymentFlowWithConfiguration:configuration];
    [self.coordinator start];
    
    UINavigationController *con = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] initWithNibName:nil bundle:nil]];
//    self.coordinator.paymentContainer.viewController
    [self presentViewController:self.coordinator.paymentContainer.viewController animated:YES completion:^{
        NSLog(@"display completed");
    }];
}

- (void)startPaymentWithBlockSyntax {
//    WALFlowConfiguration *configuration = [WALFlowConfiguration makeWithBlock:^(WALFlowConfigurationBuilder * _Nonnull builder) {
//        builder.webServiceApiClient = nil;
//    } error:&error];
}

// MARK: - Alert
- (void)displayError:(NSError *)error {
//    UIAlertController *alert = [];
}

@end
