//
//  WALFlowListener.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 31.08.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * This interface marks an interface to be a listener interface. We use it mark all the listeners
 * and as such we can put all of them into a single list. Which allows us to process them in one
 * bulk.
 */
@protocol WALFlowListener <NSObject>

@end
