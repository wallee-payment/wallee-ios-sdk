//
//  WALLoadingViewDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 a delegate which observes changes on a object (typically a view eg. WALPaymentFormView).
 
 when the observed object sends a loading state it is as such not usable and the oberver should
 indicate this. eg. by displaying a loading indicator.
 */
@protocol WALLoadingViewDelegate <NSObject>
/**
 Indicates that the object has started loading

 @param sender .
 */
- (void)viewDidStartLoading:(NSObject *)sender;

/**
 Indicates that the object has finished loading

 @param sender .
 */
- (void)viewDidFinishLoading:(NSObject *)sender;
@end
