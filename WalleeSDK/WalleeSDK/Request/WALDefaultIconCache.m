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

- (instancetype)initWithIconLoader:(id<WALIconLoader>)iconLoader iconStore:(id<WALIconStore>)iconStore {
    if (self = [super init]) {
        _iconLoader = iconLoader;
        _iconStore = iconStore;
    }
    return self;
}

- (void)fetchIcons:(NSArray <WALPaymentMethodConfiguration *> *)paymentMethodConfigurations completion:(WALPaymentIconsFetched)completion {
    NSMutableDictionary *paymentIconMap = [NSMutableDictionary dictionaryWithCapacity:paymentMethodConfigurations.count];
    __block NSError *error;
    
    dispatch_group_t iconServiceGroup = dispatch_group_create();
    
    for (WALPaymentMethodConfiguration *paymentConfiguration in paymentMethodConfigurations) {
        dispatch_group_enter(iconServiceGroup);
        [self loadIcon:paymentConfiguration completion:^(WALPaymentMethodConfiguration * _Nullable paymentMethodConfiguration, WALPaymentMethodIcon * _Nullable paymentIcon, NSError * _Nullable iconError) {
            if (!paymentIcon) {
                error = iconError;
            } else {
                paymentIconMap[paymentMethodConfiguration] = paymentIcon;
            }
            dispatch_group_leave(iconServiceGroup);
        }];
    }
    
    dispatch_group_notify(iconServiceGroup, dispatch_get_main_queue(), ^{
        // we dispatch the icon results even if there were errors (some images might still be useable)
        completion(paymentIconMap, error);
    });
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

- (void)iconLoaded {}

@end
