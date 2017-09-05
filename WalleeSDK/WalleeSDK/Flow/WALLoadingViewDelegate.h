//
//  WALLoadingViewDelegate.h
//  WalleeSDK
//
//  Created by Daniel Schmid on 05.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WALLoadingViewDelegate <NSObject>
- (void)viewDidStartLoading:(UIView *)viewController;
- (void)viewDidFinishLoading:(UIView *)viewController;
@end
