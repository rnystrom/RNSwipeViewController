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
