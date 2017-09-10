//
//  WALTranslation.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 06.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTranslation.h"

@implementation WALTranslation
+ (NSString *)localizedString:(NSString *)key {
    // check bundles
    return [[NSBundle mainBundle] localizedStringForKey:key value:nil table:nil];
}
@end
