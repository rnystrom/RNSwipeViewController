//
//  RNDirectionPanGestureRecognizer.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 10/31/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNDirectionPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@interface RNDirectionPanGestureRecognizer()

@property (assign, nonatomic, readwrite) RNDirection direction;

@end

@implementation RNDirectionPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (abs(_moveX) > kDirectionPanThreshold) {
        if (_moveX > 0) {
            _direction = RNDirectionLeft;
        }
        else {
            _direction = RNDirectionRight;
        }
        _drag = YES;
    }else if (abs(_moveY) > kDirectionPanThreshold) {
        if (_moveY > 0) {
            _direction = RNDirectionUp;
        }
        else {
            _direction = RNDirectionDown;
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
