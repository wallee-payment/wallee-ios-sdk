//
//  WALDataObject.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 12.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 BaseClass for all wallee data objects.
 this makes them not initializable directly. so use one of the provided initializers or 
 static methods
 */
@interface WALDataObject : NSObject
- (instancetype _Nullable)init NS_UNAVAILABLE;
+ (instancetype _Nullable)new __attribute__((unavailable("You should never initialize this type directly. Use the Object returned by the API")));

/**
 Return the properties by which this data object shall be sorted

 @return descriptors of how to sort multiple data objects
 */
+ (NSArray<NSSortDescriptor *> *_Nullable)sortDescriptors;
@end
