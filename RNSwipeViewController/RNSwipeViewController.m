//
//  RNSwipeViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 10/31/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNSwipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RNDirectionPanGestureRecognizer.h"
#import "UIView+Sizes.h"

static CGFloat kRNSwipeMaxFadeOpacity = 0.5f;
static CGFloat kRNSwipeDefaultDuration = 0.3f;

@interface RNSwipeViewController ()

@property (assign, nonatomic, readwrite) BOOL isToggled;

@end

@implementation RNSwipeViewController {
    UIView *_fadeView;
    
    UIView *_centerContainer;
    UIView *_leftContainer;
    UIView *_rightContainer;
    UIView *_bottomContainer;
    
    RNDirection _activeDirection;
    UIView *_activeContainer;
    
    RNDirectionPanGestureRecognizer *_panGesture;
    
    CGRect _centerOriginal;

    CGRect _leftOriginal;
    CGRect _leftActive;
    CGRect _rightOriginal;
    CGRect _rightActive;
    CGRect _bottomOriginal;
    CGRect _bottomActive;
    
    CGPoint _centerLastPoint;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (void)_init {    
    _visibleState = RNSwipeVisibleCenter;
    
    _leftVisibleWidth = 200.f;
    _rightVisibleWidth = 200.f;
    _bottomVisibleHeight = 300.0f;
    
    _activeContainer = nil;
    
    _centerOriginal = CGRectZero;
    _leftOriginal = CGRectZero;
    _rightOriginal = CGRectZero;
    _bottomOriginal = CGRectZero;
    
    _leftActive = CGRectZero;
    _rightActive = CGRectZero;
    _bottomActive = CGRectZero;
    
    _canShowBottom = YES;
    _canShowLeft = YES;
    _canShowRight = YES;
}

#pragma mark - Viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _centerContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _centerContainer.clipsToBounds = NO;
    _centerContainer.layer.masksToBounds = NO;
    
    _centerOriginal = _centerContainer.frame;
    
    _rightContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _rightContainer.width = self.rightVisibleWidth;
    
    _rightOriginal = _rightContainer.bounds;
    _rightOriginal.origin.x = _centerOriginal.size.width;
    
    _rightActive = _rightOriginal;
    _rightActive.origin.x = _centerContainer.width - _rightActive.size.width;
    
    _leftContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _leftContainer.width = self.leftVisibleWidth;
    
    _leftOriginal = _leftContainer.bounds;
    _leftOriginal.origin.x = - _leftOriginal.size.width;
    
    _leftActive = _leftOriginal;
    _leftActive.origin = CGPointZero;
    
    _bottomContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _bottomContainer.height = self.bottomVisibleHeight;
    
    _bottomOriginal = _bottomContainer.bounds;
    _bottomOriginal.origin.y = _centerOriginal.size.height;
    
    _bottomActive = _bottomOriginal;
    _bottomActive.origin.y = _centerContainer.height - _bottomActive.size.height;
    
    _centerLastPoint = CGPointZero;
    
    [self.view addSubview:_centerContainer];
    [self.view addSubview:_rightContainer];
    [self.view addSubview:_leftContainer];
    [self.view addSubview:_bottomContainer];
    
    _fadeView = [[UIView alloc] initWithFrame:_centerContainer.bounds];
    _fadeView.backgroundColor = [UIColor blackColor];
    _fadeView.alpha = 0.f;
    _fadeView.hidden = YES;
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    _panGesture = [[RNDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.delegate = self;

    [self.view addGestureRecognizer:_panGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _layoutContainersAnimated:NO duration:0.f];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Setters

- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (_centerViewController != centerViewController) {
        _centerViewController = centerViewController;
        
        [self _loadCenter];
        
        [_centerContainer addSubview:_fadeView];
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController != rightViewController) {
        rightViewController.view.frame = _rightContainer.bounds;
        _rightViewController = rightViewController;
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != leftViewController) {
        leftViewController.view.frame = _leftContainer.bounds;
        _leftViewController = leftViewController;
    }
}

- (void)setBottomViewController:(UIViewController *)bottomViewController {
    if (_bottomViewController != bottomViewController) {
        bottomViewController.view.frame = _bottomContainer.bounds;
        _bottomViewController = bottomViewController;
    }
}

- (void)setVisibleState:(RNSwipeVisible)visibleState {
    _visibleState = visibleState;
    if (visibleState == RNSwipeVisibleCenter) {
        // remove shadows
        [UIView animateWithDuration:0.1f
                              delay:0
                            options:kNilOptions
                         animations:^{
                             _leftContainer.layer.shadowOpacity = 0.f;
                             
                             _rightContainer.layer.shadowOpacity = 0.f;
                             
                             _bottomContainer.layer.shadowOpacity = 0.f;
                         }
                         completion:^(BOOL finished) {
                             _leftContainer.layer.shadowRadius = 0.f;
                             _leftContainer.layer.shadowColor = nil;
                             
                             _rightContainer.layer.shadowRadius = 0.f;
                             _rightContainer.layer.shadowColor = nil;
                             
                             _bottomContainer.layer.shadowRadius = 0.f;
                             _bottomContainer.layer.shadowColor = nil;
                         }];
    }
}

#pragma mark - Getters

- (UIViewController*)visibleController {
    if (self.visibleState == RNSwipeVisibleLeft) return self.leftViewController;
    if (self.visibleState == RNSwipeVisibleRight) return self.rightViewController;
    if (self.visibleState == RNSwipeVisibleBottom) return self.bottomViewController;
    return self.centerViewController;
}

- (BOOL)canShowBottom {
    if (! self.bottomViewController) {
        return NO;
    }
    return _canShowBottom;
}

- (BOOL)canShowLeft {
    if (! self.leftViewController) {
        return NO;
    }
    return _canShowLeft;
}

- (BOOL)canShowRight {
    if (! self.rightViewController) {
        return NO;
    }
    return _canShowRight;
}

#pragma mark - Gesture recognizer delegate 

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - Private Helpers

- (void)_layoutContainersAnimated:(BOOL)animate duration:(NSTimeInterval)duration {
    CGRect leftFrame = self.view.bounds;
    CGRect rightFrame = self.view.bounds;
    CGRect bottomFrame = self.view.bounds;

    leftFrame.size.width = self.leftVisibleWidth;;
    leftFrame.origin.x = leftFrame.size.width * -1;
    
    rightFrame.size.width = self.rightVisibleWidth;
    rightFrame.origin.x = _centerContainer.frame.origin.x + _centerContainer.frame.size.width;
    
    bottomFrame.size.height = self.bottomVisibleHeight;
    bottomFrame.origin.y = self.view.bounds.size.height;
    
    void (^block)(void) = [self _toResetContainers];
    
    if (animate) {
        [UIView animateWithDuration:kRNSwipeDefaultDuration
                              delay:0
                            options:kNilOptions
                         animations:block
                         completion:^(BOOL finished){
                             if (finished) {
                                 self.isToggled = NO;
                                 _centerLastPoint = CGPointZero;
                                 _fadeView.hidden = YES;
                             }
                         }];
    }
    else {
        block();
    }
    
}

- (void (^)(void))_toResetContainers {
    return ^{
        _leftContainer.frame = _leftOriginal;
        _rightContainer.frame = _rightOriginal;
        _bottomContainer.frame = _bottomOriginal;
        _centerContainer.frame = _centerOriginal;
        _fadeView.alpha = 0.f;
    };
}

#pragma mark - Adding Views

- (void)_loadCenter {
    if (self.centerViewController && ! self.centerViewController.view.superview) {
        self.centerViewController.view.frame = _centerContainer.bounds;
        [_centerContainer addSubview:self.centerViewController.view];
    }
}

- (void)_loadLeft {
    if (self.leftViewController && ! self.leftViewController.view.superview) {
        self.leftViewController.view.frame = _leftContainer.bounds;
        [_leftContainer addSubview:self.leftViewController.view];
    }
}

- (void)_loadRight {
    if (self.rightViewController && ! self.rightViewController.view.superview) {
        self.rightViewController.view.frame = _rightContainer.bounds;
        [_rightContainer addSubview:self.rightViewController.view];
    }
}

- (void)_loadBottom {
    if (self.bottomViewController && ! self.bottomViewController.view.superview) {
        self.bottomViewController.view.frame = _bottomContainer.bounds;
        [_bottomContainer addSubview:self.bottomViewController.view];
    }
}

#pragma mark - Animations

- (CGFloat)_filterTop:(CGFloat)translation {
    if (! self.canShowBottom) {
        return 0.f;
    }
    
    if (_centerContainer.top >= 0.f) {
        return 0.f;
    }
    return translation + _centerLastPoint.y;
}

- (CGFloat)_filterLeft:(CGFloat)translation {
    if (! self.canShowRight) {
        return 0.f;
    }
    
    if (_centerContainer.left <= -1 * self.rightVisibleWidth) {
        return self.rightVisibleWidth * -1 + translation / 10.f;
    }
    return translation + _centerLastPoint.x;
}

- (CGFloat)_filterRight:(CGFloat)translation {
    if (! self.canShowLeft) {
        return 0.f;
    }
    
    if (_centerContainer.left >= self.leftVisibleWidth) {
        return self.leftVisibleWidth + translation / 10.f;
    }
    return translation + _centerLastPoint.x;
}

- (CGFloat)_filterBottom:(CGFloat)translation {
    if (! self.canShowBottom) {
        return 0.f;
    }
    
    if (abs(_centerContainer.top) >= self.bottomVisibleHeight) {
        return self.bottomVisibleHeight * -1;
    }
    return translation + _centerLastPoint.y;
}

- (void)_sendCenterToPoint:(CGPoint)centerPoint panel:(UIView*)container toPoint:(CGPoint)containerPoint {
    [UIView animateWithDuration:kRNSwipeDefaultDuration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         _centerContainer.origin = centerPoint;
                         container.origin = containerPoint;
                         _fadeView.alpha = kRNSwipeMaxFadeOpacity;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _centerLastPoint = _centerContainer.origin;
                             _activeContainer.layer.shouldRasterize = NO;
                         }
                     }];
}

- (void)_handlePan:(RNDirectionPanGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _activeDirection = recognizer.direction;
        
        switch (_activeDirection) {
            case RNDirectionLeft: {
                [self _loadRight];
                [self _loadLeft];
                _activeContainer = _rightContainer;
            }
                break;
            case RNDirectionRight: {
                [self _loadRight];
                [self _loadLeft];
                _activeContainer = _leftContainer;
            }
                break;
            case RNDirectionDown:
            case RNDirectionUp: {
                _activeContainer = _bottomContainer;
                [self _loadBottom];
            }
                break;
        }
        
        _activeContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _activeContainer.layer.shadowRadius = 5.f;
        _activeContainer.layer.shadowOffset = CGSizeZero;
        _activeContainer.layer.shadowOpacity = 0.5f;
        _activeContainer.layer.shouldRasterize = YES;
        
        _fadeView.hidden = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translate = [recognizer translationInView:_centerContainer];
        BOOL doFade = NO;
        
        switch (_activeDirection) {
            case RNDirectionLeft:
            case RNDirectionRight: {
                if (self.visibleState != RNSwipeVisibleBottom) {
                    CGFloat left = recognizer.direction == RNDirectionLeft ? [self _filterLeft:translate.x] : [self _filterRight:translate.x];
                    _centerContainer.left = left;
                    _rightContainer.left = _centerContainer.right;
                    _leftContainer.right= _centerContainer.left;
                    doFade = YES;
                }
            }
                break;
            case RNDirectionDown: {
                if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                    _centerContainer.top = [self _filterTop:translate.y];
                    _activeContainer.top = _bottomOriginal.origin.y + [self _filterTop:translate.y];
                    doFade = YES;
                }
            }
                break;
            case RNDirectionUp: {
                if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                    _centerContainer.top = [self _filterBottom:translate.y];
                    _activeContainer.top = _bottomOriginal.origin.y + [self _filterBottom:translate.y];
                    doFade = YES;
                }
            }
                break;
        }

        if (doFade) {
            CGFloat position = 0.f;
            CGFloat threshold = 0.f;
            switch (_activeDirection) {
                case RNDirectionLeft: {
                    position = abs(_centerContainer.left);
                    threshold = self.rightVisibleWidth;
                }
                    break;
                case RNDirectionRight: {
                    position = abs(_centerContainer.left);
                    threshold = self.leftVisibleWidth;
                }
                    break;
                case RNDirectionDown:
                case RNDirectionUp: {
                    position = abs(_centerContainer.top);
                    threshold = self.bottomVisibleHeight;
                }
                    break;
            }
            CGFloat alpha = kRNSwipeMaxFadeOpacity * (position / (CGFloat)threshold);
            if (alpha > kRNSwipeMaxFadeOpacity) alpha = kRNSwipeMaxFadeOpacity;
            _fadeView.alpha = alpha;
        }
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_centerContainer.left > self.leftVisibleWidth / 2.f) {
            [self _sendCenterToPoint:CGPointMake(self.leftVisibleWidth, 0) panel:_leftContainer toPoint:_leftActive.origin];
            self.visibleState = RNSwipeVisibleLeft;
        }
        else if (_centerContainer.left < (self.rightVisibleWidth / -2.f)) {
            [self _sendCenterToPoint:CGPointMake(-1 * self.rightVisibleWidth, 0) panel:_rightContainer toPoint:_rightActive.origin];
            self.visibleState = RNSwipeVisibleRight;
        }
        else if (_centerContainer.top < self.bottomVisibleHeight / -2.f) {
            [self _sendCenterToPoint:CGPointMake(0, -1 * self.bottomVisibleHeight) panel:_bottomContainer toPoint:_bottomActive.origin];
            self.visibleState = RNSwipeVisibleBottom;
        }
        else {
            [self _layoutContainersAnimated:YES duration:kRNSwipeDefaultDuration];
            self.visibleState = RNSwipeVisibleCenter;
        }
    }
}

@end
