//
//  RNDirectionPanGestureRecognizer.h
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 10/31/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum : u_int16_t {
    RNDirectionUp = 0x0,
    RNDirectionDown = 0x1,
    RNDirectionLeft = 0x2,
    RNDirectionRight = 0x3
} RNDirection;

/** Subclass of UIPanGestureRecognizer that adds a directional property. */
@interface RNDirectionPanGestureRecognizer : UIPanGestureRecognizer

/** The direction of the gesture.
 
 Possible values are of type RNDirection
 
 - RNDirectionUp
 - RNDirectionDown
 - RNDirectionLeft
 - RNDirectionRight
 
 @see [UIPanGestureRecognizer](http://developer.apple.com/library/ios/#documentation/uikit/reference/UIPanGestureRecognizer_Class/Reference/Reference.html)
 */
@property (assign, nonatomic, readonly) RNDirection direction;

@end
