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

#import "WALDefaultTheme.h"
#import "WALPaymentMethodTableViewCell.h"

#import "WALTranslation.h"

static NSString * const cellIdentifier = @"defaultCell";

@interface WALDefaultTokenListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WALDefaultTokenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = self.theme.primaryBackgroundColor;
    self.title = WALLocalizedString(@"token_list_title", @"title for the token list view controller");
}

- (BOOL)isEqual:(id)object {
    // we can override this to use pop animation on navigationControllers setViewController
    return [object isKindOfClass:self.class];
}

- (void)addSubviewsToContentView:(UIView *)contentView {
    CGFloat height = self.loadedTokens.tokenVersions.count * WALPaymentMethodTableViewCell.defaultCellHeight;
    CGRect tableRect = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y, contentView.bounds.size.width, height);
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.tableView.scrollEnabled = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.theme.secondaryBackgroundColor;
    [contentView addSubview:self.tableView];
}

- (CGSize)contentSize {
    return CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height);
}

- (NSString *)confirmationTitle {
    return WALLocalizedString(@"token_list_chose_payment_method", @"the title of the button to select another pament method");
}

- (NSString *)backTitle {
    return WALLocalizedString(@"token_list_go_back", @"the title of the button to step back out of the payment process");
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WALPaymentMethodTableViewCell.defaultCellHeight;
}

- (void)confirmationTapped:(id)sender {
    self.onPaymentMethodChange();
}

- (void)backTapped:(id)sender {
    self.onBack();
}

@end
