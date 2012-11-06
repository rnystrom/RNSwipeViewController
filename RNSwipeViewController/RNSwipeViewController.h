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

typedef enum : u_int16_t {
    RNSwipeVisibleLeft = 0x0,
    RNSwipeVisibleCenter = 0x1,
    RNSwipeVisibleRight = 0x2,
    RNSwipeVisibleBottom = 0x3
} RNSwipeVisible;

/** Notification posted when controller will show the left view controller */
extern NSString * const RNSwipeViewControllerLeftWillAppear;

/** Notification posted when controller did show the left view controller */
extern NSString * const RNSwipeViewControllerLeftDidAppear;

/** Notification posted when controller will show the right view controller */
extern NSString * const RNSwipeViewControllerRightWillAppear;

/** Notification posted when controller did show the right view controller */
extern NSString * const RNSwipeViewControllerRightDidAppear;

/** Notification posted when controller will show the bottom view controller */
extern NSString * const RNSwipeViewControllerBottomWillAppear;

/** Notification posted when controller did show the bottom view controller */
extern NSString * const RNSwipeViewControllerBottomDidAppear;

/** Notification posted when controller will show the center view controller */
extern NSString * const RNSwipeViewControllerCenterWillAppear;

/** Notification posted when controller did show the center view controller */
extern NSString * const RNSwipeViewControllerCenterDidAppear;

#import <UIKit/UIKit.h>
#import "RNSwipeViewControllerDelegate.h"

/** Handles the organization and displaying of view controllers.
 
 An RNSwipeViewController instance should be initialized first and then assigned a left, right, and/or bottom view controllers before adding to your scene. RNSwipeViewController is a class that should be used similar to UINavigationController in that it is a master controller who's displayed view controllers contain all logic and view data.
 */
@interface RNSwipeViewController : UIViewController
<UIGestureRecognizerDelegate>

///---------------------------------------------------------------------------------------
/// @name Methods
///---------------------------------------------------------------------------------------

/** Show the left view controller
 
 @see resetView
 */
- (void)showLeft;

/** Show the left view controller with a user-defined duration.
 
 @param duration The duration of the animation.
 @see resetView
 */
- (void)showLeftWithDuration:(NSTimeInterval)duration;

/** Show the right view controller
 
 @see resetView
 */
- (void)showRight;

/** Show the right view controller with a user-defined duration.
 
 @param duration The duration of the animation.
 @see resetView
 */
- (void)showRightWithDuration:(NSTimeInterval)duration;

/** Show the bottom view controller
 
 @see resetView
 */
- (void)showBottom;

/** Show the bottom view controller with a user-defined duration.
 
 @param duration The duration of the animation.
 @see resetView
 */
- (void)showBottomWithDuration:(NSTimeInterval)duration;

/** Hide all view controllers and show the center controller.
 
 @see resetView
 */
- (void)resetView;

///---------------------------------------------------------------------------------------
/// @name Controllers
///---------------------------------------------------------------------------------------

/** The center view controller that is always displayed;
 
 The center controller is always visible. When another controller is swiped overtop a fading effect covers the center controller but it is still visible.
 
 @see visibleController
 */
@property (strong, nonatomic) UIViewController *centerViewController;

/** The left view controller that can be displayed with a right-swipe.
 
 @see visibleController
 */
@property (strong, nonatomic) UIViewController *leftViewController;

/** The bottom view controller that can be displayed with an up-swipe.
 
 @see visibleController
 */
@property (strong, nonatomic) UIViewController *bottomViewController;

/** The right view controller that can be displayed with a left-swipe.
 
 @see visibleController
 */
@property (strong, nonatomic) UIViewController *rightViewController;

///---------------------------------------------------------------------------------------
/// @name Controller Properties
///---------------------------------------------------------------------------------------

/** The width in points of the left controller.
 
 This value should be less than the device's visible width.
 
 @see leftViewController
 */
@property (assign, nonatomic) CGFloat leftVisibleWidth;

/** The width in points of the left controller.
 
 This value should be less than the device's visible width.
 
 @see rightViewController
 */
@property (assign, nonatomic) CGFloat rightVisibleWidth;

/** The width in points of the left controller.
 
 This value should be less than the device's visible width.
 
 @see bottomViewController
 */
@property (assign, nonatomic) CGFloat bottomVisibleHeight;

///---------------------------------------------------------------------------------------
/// @name Controller Status
///---------------------------------------------------------------------------------------

/** Utility method useable with KVO.
 
 @see visibleController
 @see visibleState
 */
@property (assign, nonatomic, readonly) BOOL isToggled;

/** The state of the overall control.
 
 Possible values are of type RNSwipeVisible
 
 - RNSwipeVisibleLeft
 - RNSwipeVisibleCenter
 - RNSwipeVisibleRight
 - RNSwipeVisibleBottom
 
 @see isToggled
 @see visibleController
 */
@property (assign, nonatomic) RNSwipeVisible visibleState;

/** Returns the currently visible controller.
 
 @see isToggled
 @see visibleState
 */
@property (readonly, nonatomic) UIViewController *visibleController;

///---------------------------------------------------------------------------------------
/// @name Controller Utilities
///---------------------------------------------------------------------------------------

/** Enable/disable the left view controller.
 
 Default YES;
 
 @see canShowRight
 @see canShowBottom
 */
@property (assign, nonatomic) BOOL canShowLeft;

/** Enable/disable the right view controller.
 
 Default YES;
 
 @see canShowLeft
 @see canShowBottom
 */
@property (assign, nonatomic) BOOL canShowRight;

/** Enable/disable the bottom view controller.
 
 Default YES;
 
 @see canShowLeft
 @see canShowRight
 */
@property (assign, nonatomic) BOOL canShowBottom;

/** Enable/disable the bottom view controller.
 
 Default YES;
 */
@property (assign, nonatomic) BOOL canTapOut;

///---------------------------------------------------------------------------------------
/// @name Controller Delegates
///---------------------------------------------------------------------------------------

/** Optional delegate to receive messages that a view controller is being displayed.
 
 @see RNSwipeViewControllerDelegate
 */
@property (weak) NSObject <RNSwipeViewControllerDelegate> *swipeDelegate;

@end