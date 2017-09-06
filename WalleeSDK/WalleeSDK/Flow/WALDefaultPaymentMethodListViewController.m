//
//  WALDefaultPaymentMethodListViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultPaymentMethodListViewController.h"
#import "WALPaymentMethodConfiguration.h"

static NSString * const cellIdentifier = @"defaultCell";

@interface WALDefaultPaymentMethodListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WALDefaultPaymentMethodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.title = @"Select PaymentMethod";
}

// MARK: - TableViewDelegate and Datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WALPaymentMethodConfiguration *method = self.paymentMethods[indexPath.row];
    if (self.onPaymentMethodSelected) {
        self.onPaymentMethodSelected(method);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paymentMethods.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WALPaymentMethodConfiguration *method = self.paymentMethods[indexPath.row];
    cell.textLabel.text = method.name;
    
    return cell;
    //    cell.imageView
}

@end
