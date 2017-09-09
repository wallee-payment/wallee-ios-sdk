//
//  WALDefaultTokenListViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultTokenListViewController.h"
#import "WALTokenVersion.h"
#import "WALLoadedTokens.h"
#import "WALConnectorConfiguration.h"

#import "WALPaymentMethodTableViewCell.h"

static NSString * const cellIdentifier = @"defaultCell";

@interface WALDefaultTokenListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *paymentMethodButton;
@end

@implementation WALDefaultTokenListViewController

- (BOOL)isEqual:(id)object {
    // we can override this to use pop animation on navigationControllers setViewController
    return [object isKindOfClass:self.class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect buttonRect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 44.0);
    self.paymentMethodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.paymentMethodButton.frame = buttonRect;
    self.paymentMethodButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.paymentMethodButton setTitle:@"Other" forState:UIControlStateNormal];
    self.paymentMethodButton.tintColor = [UIButton appearance].tintColor;
    self.paymentMethodButton.backgroundColor = UIColor.lightGrayColor;
    [self.paymentMethodButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.paymentMethodButton];
    
    
    CGRect tableRect = CGRectMake(buttonRect.origin.x, buttonRect.size.height, buttonRect.size.width, self.view.bounds.size.height - buttonRect.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.title = @"Select Token";
}

// MARK: - TableViewDelegate and Datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WALTokenVersion *token = self.loadedTokens.tokenVersions[indexPath.row];
    if (self.onTokenSelected) {
        self.onTokenSelected(token);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loadedTokens.tokenVersions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WALPaymentMethodTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WALPaymentMethodTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WALTokenVersion *token = self.loadedTokens.tokenVersions[indexPath.row];
    WALPaymentMethodIcon *icon = self.loadedTokens.paymentMethodIcons[token.paymentConnectorConfiguration.paymentMethodConfiguration];
    [cell configureWith:token.name paymentIcon:icon];
    
    return cell;
//    cell.imageView
}

- (void)buttonTapped:(id)sender {
    if (sender == self.paymentMethodButton) {
        self.onPaymentMethodChange();
    }
}

@end
