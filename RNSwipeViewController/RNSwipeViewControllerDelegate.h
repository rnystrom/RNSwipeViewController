/*
 * RNSwipeViewController
 *
 * Created by Ryan Nystrom on 10/2/12.
 * Copyright (c) 2012 Ryan Nystrom. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>

@class RNSwipeViewController;

/** Protocol for RNSwipeViewController's delegate to notify of future and past transitions. */
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
