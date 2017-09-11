//
//  WALTranslation.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 06.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALTranslation.h"

/**
 WALTranslationInternal is a private class dedicatet to locate help find our bundle
 */
@interface WALTranslationInternal : NSObject 
@end
@implementation WALTranslationInternal
@end

@implementation WALTranslation
+ (NSString *)localizedString:(NSString *)key {
    // try load from main
    NSString * string = [[NSBundle mainBundle] localizedStringForKey:key value:nil table:nil];
    if (![string isEqualToString:key]) {
        return string;
    }
    //load from our bundle
    NSBundle *bundle = [NSBundle bundleForClass:[WALTranslationInternal class]];
    return [bundle localizedStringForKey:key value:nil table:nil];
}
@end
