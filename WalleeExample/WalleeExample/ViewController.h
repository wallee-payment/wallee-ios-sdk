//
//  ViewController.h
//  WalleeExample
//
//  Created by Daniel Schmid on 14.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WalleeSDK;

@interface ViewController : UIViewController<WALPaymentFlowDelegate>
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

- (IBAction)didTapPayment:(id)sender;
@end

