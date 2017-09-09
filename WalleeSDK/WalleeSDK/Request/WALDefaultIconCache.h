//
//  WALDefaultIconCache.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 08.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALIconCache.h"
@protocol WALIconLoader, WALIconStore;

@interface WALDefaultIconCache : NSObject<WALIconCache>
- (instancetype)initWithIconLoader:(id<WALIconLoader>)iconLoader iconStore:(id<WALIconStore>)iconStore ;
@end
