//
//  ViewController.m
//  WalleeExample
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "ViewController.h"
#import "TestCredentialsFetcher.h"

//#import <WalleSDK/WALFlowCoordinator.h>
@import WalleeSDK;

@interface ViewController ()
@property (nonatomic, strong) WALFlowCoordinator *coordinator;
@property (nonatomic, strong) UIColor *successColor;
@property (nonatomic, strong) UIColor *failureColor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.successColor = [UIColor colorWithRed:0.165 green:0.749 blue:0.035 alpha:1.0];
    self.failureColor = [UIColor colorWithRed:0.937 green:0.314 blue:0.314 alpha:1.0];
    self.messageView.hidden = YES;
    self.messageLabel.textColor = UIColor.whiteColor;
}

- (IBAction)didTapPayment:(id)sender {
    [self startPaymentWithBuilderSyntax];
}

- (void)startPaymentWithBuilderSyntax {
    NSError *error;
    TestCredentialsFetcher *fetcher = [[TestCredentialsFetcher alloc] init];
    WALFlowConfigurationBuilder *builder = [[WALFlowConfigurationBuilder alloc] initWithCredentialsFetcher:fetcher operationQueue:nil];
    //additional setup
    builder.delegate = self;
    
    WALFlowConfiguration *configuration = [WALFlowConfiguration makeWithBuilder:builder error:&error];
    if (!configuration) {
        [self displayError:error];
        return;
    }
    
    self.coordinator = [WALFlowCoordinator paymentFlowWithConfiguration:configuration];
    [self.coordinator start];

    [self presentViewController:self.coordinator.paymentContainer.viewController animated:YES completion:^{
        NSLog(@"display completed");
    }];
}

- (void)startPaymentWithBlockSyntax {
//    WALFlowConfiguration *configuration = [WALFlowConfiguration makeWithBlock:^(WALFlowConfigurationBuilder * _Nonnull builder) {
//        builder.webServiceApiClient = nil;
//    } error:&error];
}

// MARK: - Delegate
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator  encouteredApiError:(NSError *)error {
    [self handleError:error];
}
- (void)flowCoordinator:(WALFlowCoordinator *)coordinator encouteredInternalError:(NSError *)error {
    [self handleError:error];
}

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidSucceed:(WALTransaction *)transaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageView.hidden = NO;
        self.messageView.backgroundColor = self.successColor;
        self.messageLabel.text = @"The Payment was successful.";
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)flowCoordinator:(WALFlowCoordinator *)coordinator transactionDidFail:(WALTransaction *)transaction {
    NSError *error;
    [WALErrorHelper populate:&error withFailedTransaction:transaction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self handleError:error];
    });
}

// MARK: - Helpers
- (void)handleError:(NSError *)error {
    NSLog(@"Transaction ended in Error: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.messageView.hidden = NO;
        self.messageView.backgroundColor = self.failureColor;
        self.messageLabel.text = @"The Payment was not completed.";
            [self dismissViewControllerAnimated:YES completion:^{
                [self displayError:error];
            }];
        
    });
}

- (void)displayError:(NSError * _Nullable)error {
    if (!error) {
        return;
    }
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[NSString stringWithFormat:@"Error Code: %ld", (long)error.code]
                                message:error.localizedDescription
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction
                           actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                               
                           }];
    
    [alert addAction:okay];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
