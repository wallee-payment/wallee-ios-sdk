//
//  WALNSURLIconLoader.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 07.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WALIconLoader.h"

@interface WALNSURLIconLoader : NSObject<WALIconLoader>
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)iconLoaderWithOperationQueue:(NSOperationQueue *_Nullable)queue;
NS_ASSUME_NONNULL_END
@end
