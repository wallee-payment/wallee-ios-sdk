//
//  WALExpiringViewDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
  This interface defines a view to expire automatically after awhile. The listener allows to act on
  the fact when the view is expired.
 */
@protocol WALExpiringViewDelegate <NSObject>
/**
  This method is invoked when the viewController has been expired. The implementor should take some
  action to solve this issue. For example reload the view or remove it and cancel the payment
  process.
 
  @param viewController the viewController which has been expired.
 */
- (void)viewControllerDidExpire:(UIViewController *)viewController;
@end
