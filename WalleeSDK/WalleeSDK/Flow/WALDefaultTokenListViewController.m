//
//  WALDefaultTokenListViewController.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 01.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultTokenListViewController.h"
#import "WALTokenVersion.h"

static NSString * const cellIdentifier = @"defaultCell";

@interface WALDefaultTokenListViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WALDefaultTokenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// MARK: - TableViewDelegate and Datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WALTokenVersion *token = self.tokens[indexPath.row];
    if (self.onTokenSelectionBlock) {
        self.onTokenSelectionBlock(token);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokens.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    WALTokenVersion *token = self.tokens[indexPath.row];
    cell.textLabel.text = token.name;
    
    return cell;
//    cell.imageView
}

@end
