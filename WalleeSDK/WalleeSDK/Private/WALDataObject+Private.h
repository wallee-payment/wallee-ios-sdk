//
//  WALDataObject+Private.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 12.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALDataObject.h"

/**
 Private category to make the data objects be able to initialize them selfes
 */
@interface WALDataObject (Private)
NS_ASSUME_NONNULL_BEGIN
- (instancetype)initInternal;
NS_ASSUME_NONNULL_END
@end
