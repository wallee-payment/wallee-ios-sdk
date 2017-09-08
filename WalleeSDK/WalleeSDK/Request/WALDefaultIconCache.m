//
//  WALDefaultIconCache.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDefaultIconCache.h"

#import "WALIconLoader.h"
#import "WALIconStore.h"

#import "WALPaymentMethodIcon.h"
#import "WALPaymentMethodConfiguration.h"

typedef void(^WALSingleIconLoadedCompletion)(WALPaymentMethodConfiguration * _Nullable paymentMethodConfiguration, WALPaymentMethodIcon *_Nullable paymentIcon, NSError *_Nullable error);

@interface WALDefaultIconCache ()
@property (nonatomic, strong) id<WALIconStore> iconStore;
@property (nonatomic, strong) id<WALIconLoader> iconLoader;

@end

@implementation WALDefaultIconCache

- (instancetype)initWithIconLoader:(id<WALIconLoader>)iconLoader {
    if (self = [super init]) {
        _iconLoader = iconLoader;
    }
    return self;
}

- (void)fetchIcons:(NSArray *)paymentMethodConfigurations completion:(WALPaymentIconsFetched)completion {
    
}

- (void)loadIcon:(WALPaymentMethodConfiguration *)paymentMethodConfiguration completion:(WALSingleIconLoadedCompletion)completion {
    WALPaymentMethodIcon *paymentIcon = [self.iconStore getIcon:paymentMethodConfiguration];
    if (paymentIcon) {
        completion(paymentMethodConfiguration, paymentIcon, nil);
        return;
    }
    
    [self.iconLoader fetchIcon:paymentMethodConfiguration completion:^(WALPaymentMethodConfiguration * _Nullable paymentMethod, WALPaymentMethodIcon * _Nullable paymentMethodIcon, NSError * _Nullable error) {
        
        if (!paymentMethodIcon) {
            completion(nil, nil, error);
            return;
        }
        
        completion(paymentMethodConfiguration, paymentMethodIcon, nil);        
    }];
}

@end
