//
//  WALPaymentMethodTableViewCell.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 09.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WALPaymentMethodTableViewCell.h"

#import "WALPaymentMethodConfiguration.h"
#import "WALPaymentMethodIcon.h"

@interface WALPaymentMethodTableViewCell ()
@property (nonatomic, retain) UILabel *paymentNameLabel;
@property (nonatomic, retain) WKWebView *paymentImageWebView;
@end

@implementation WALPaymentMethodTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initializeViews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initializeViews];
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initializeViews];
    return self;
}

- (void)initializeViews {
    CGRect origin = self.contentView.bounds;
    CGRect imageRect = CGRectMake(origin.origin.x, origin.origin.y, origin.size.height, origin.size.height);
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.paymentImageWebView = [[WKWebView alloc] initWithFrame:imageRect configuration:configuration];
    self.paymentImageWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.paymentImageWebView];
    
    CGRect labelRect = CGRectMake(imageRect.size.width, origin.origin.y, origin.size.width - imageRect.size.width, origin.size.height);
    self.paymentNameLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.paymentNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview:self.paymentNameLabel];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configureWith:(NSString *)paymentName paymentIcon:(WALPaymentMethodIcon *)paymentIcon {
    self.paymentNameLabel.text = paymentName;
    if (paymentIcon) {
        [self.paymentImageWebView loadHTMLString:paymentIcon.dataAsString baseURL:nil];
    }
}

- (void)prepareForReuse {
    self.paymentNameLabel.text = nil;
    [self.paymentImageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
