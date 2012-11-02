//
//  RNDirectionPanGestureRecognizer.h
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 10/31/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    RNDirectionUp,
    RNDirectionDown,
    RNDirectionLeft,
    RNDirectionRight
} RNDirection;

@interface RNDirectionPanGestureRecognizer : UIPanGestureRecognizer

@property (assign, nonatomic, readonly) RNDirection direction;

@end
