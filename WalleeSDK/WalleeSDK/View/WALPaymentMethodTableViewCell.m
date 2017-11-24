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

#import "WALDefaultTheme.h"

@interface WALPaymentMethodTableViewCell ()
@property (nonatomic, retain) UILabel *paymentNameLabel;
@property (nonatomic, retain) WKWebView *paymentImageWebView;
@property (nonatomic, strong) WALPaymentMethodIcon *icon;
@end

@implementation WALPaymentMethodTableViewCell

+ (CGFloat)defaultCellHeight {
    return 50.0;
}

+ (CGFloat)defaultImageWidth {
    return 75.0;
}

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect origin = self.contentView.bounds;
    CGRect imageRect = CGRectMake(origin.origin.x, origin.origin.y, origin.size.height, origin.size.height);
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.paymentImageWebView = [[WKWebView alloc] initWithFrame:imageRect configuration:configuration];
    self.paymentImageWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.paymentImageWebView.scrollView.scrollEnabled = false;
    self.paymentImageWebView.userInteractionEnabled = false;
    self.paymentImageWebView.scrollView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.paymentImageWebView.scrollView.contentInset = UIEdgeInsetsZero;
    
    [self.contentView addSubview:self.paymentImageWebView];
    
    CGRect labelRect = CGRectMake(imageRect.size.width, origin.origin.y, origin.size.width - imageRect.size.width, origin.size.height);
    self.paymentNameLabel = [[UILabel alloc] initWithFrame:labelRect];
    self.paymentNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.paymentNameLabel];
}

+ (NSString *)wrapInHTML:(NSString *)content contentType:(NSString *)contentType forSize:(CGSize)size {
    CGFloat dimension = fmax(size.height, size.width);
    
    NSString *viewportHTML = [NSString stringWithFormat:@"<meta charset=\"UTF-8\" name=\"viewport\" content=\"width=%.0f, shrink-to-fit=YES, maximum-scale=1.0; initial-scale=1.0\"><style>img{max-width:100%%;max-height:100%% !important;width:auto !important;};</style>", dimension];
    
    NSString *imageTagString = @"        <img style=\"margin:0;padding:0\" alt=\"tick\" src=\"data:%@"
    @"        ;base64,%@\" />";
    
    NSString *imageTag = [NSString stringWithFormat:imageTagString, contentType, content];
    
    NSString *htmlWrapper = @"<!DOCTYPE html><html style=\"overflow: hidden\">"
    @"    <head>%@</head><body style=\"overflow: hidden; margin:0; text-align:center; padding:0;\">"
    @"      <div style=\"display: -webkit-flex; align-items:center; justify-content:center; height:%.0fpx\">"
    @"        %@"
    @"      </div>"
    @"    </body></html>";
    
    NSString *wrappedString = [NSString stringWithFormat:htmlWrapper, viewportHTML, size.height, imageTag];
    return wrappedString;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)applyTheme {
    if (!self.theme) {
        self.theme = [WALDefaultTheme defaultTheme];
    }
    self.backgroundColor = self.theme.secondaryBackgroundColor;
    self.contentView.backgroundColor = self.theme.secondaryBackgroundColor;
    
    self.paymentNameLabel.font = self.theme.font;
    self.paymentNameLabel.textColor = self.theme.primaryColor;
}

- (void)configureWith:(NSString *)paymentName paymentIcon:(WALPaymentMethodIcon *)paymentIcon {
    [self applyTheme];
    self.icon = paymentIcon;
    self.paymentNameLabel.text = paymentName;
    [self updateIcon];
}

- (void)updateIcon {
    if (self.icon) {
        NSString *htmlyfiedString = [WALPaymentMethodTableViewCell wrapInHTML:self.icon.dataAsBase64String
                                                                  contentType:self.icon.mimeType
                                                                      forSize:self.paymentImageWebView.frame.size];
        [self.paymentImageWebView loadHTMLString:htmlyfiedString baseURL:nil];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.paymentNameLabel.text = nil;
    [self.paymentImageWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    static CGFloat contentVertPadding = 10.0f;
    static CGFloat contentHozPadding = 5.0f;
    CGRect origin = self.contentView.bounds;
    CGRect imageRect = CGRectMake(contentVertPadding + origin.origin.x, origin.origin.y + contentHozPadding, WALPaymentMethodTableViewCell.defaultImageWidth, origin.size.height - 2*contentHozPadding);
    self.paymentImageWebView.frame = imageRect;
    
    CGFloat labelX = imageRect.origin.x + imageRect.size.width + contentVertPadding;
    CGRect labelRect = CGRectMake(labelX, origin.origin.y, origin.size.width - imageRect.size.width, origin.size.height);
    self.paymentNameLabel.frame = labelRect;

    [self updateIcon];
}

@end
