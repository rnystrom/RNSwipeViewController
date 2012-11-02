//
//  RNSwipeViewControllerDelegate.h
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 11/2/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RNSwipeViewController;

@protocol RNSwipeViewControllerDelegate <NSObject>

@optional

/**
 Informs the delegate that a view controller is going to appear.
 
 This is an optional protocol method that will fire even if the view controller is swiped back into hiding after it appears. swipeController:didShowController: is not necessarily called after this method. Also, a view controller will not necessarily be displayed following this method's calling.
 
 @param swipeController The swipe controller handling touch events and presentation of a view controller.
 @param controller The view controller to be displayed.
 @see swipeController:didShowController:
 */
- (void)swipeController:(RNSwipeViewController*)swipeController willShowController:(UIViewController*)controller;

/**
 Informs the delegate that a view controller is did appear.
 
 This is an optional protocol method that is called after a view controller appears. This method is only called after all animations are complete.
 
 @param swipeController The swipe controller handling touch events and presentation of a view controller.
 @param controller The view controller that was displayed
 @see swipeController:willShowController:
 */
- (void)swipeController:(RNSwipeViewController*)swipeController didShowController:(UIViewController*)controller;

@end
