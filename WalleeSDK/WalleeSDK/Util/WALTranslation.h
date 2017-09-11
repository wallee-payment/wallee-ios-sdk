//
//  WALTranslation.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 06.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WALTranslation : NSObject
+ (NSString * _Nullable)localizedString:(NSString * _Nonnull)key;

@end

static inline NSString * _Nonnull WALLocalizedString(NSString* _Nonnull key, NSString * _Nullable __unused comment) {
    return [WALTranslation localizedString:key];
}
