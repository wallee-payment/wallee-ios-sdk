//
//  WALDefaultStateBaseViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 10.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultStateBaseViewController.h"

#import "WALDefaultTheme.h"

@interface WALDefaultStateBaseViewController ()

@end

@implementation WALDefaultStateBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.theme.primaryBackgroundColor;
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20.0, 0.0)];
    self.stateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.stateLabel.numberOfLines = 0;
    [self.view addSubview:self.stateLabel];
}


@end
