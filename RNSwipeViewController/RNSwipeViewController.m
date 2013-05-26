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

#import "RNSwipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RNDirectionPanGestureRecognizer.h"
#import "UIView+Sizes.h"
#import "UIApplication+AppDimensions.h"
#import "RNRevealViewControllerProtocol.h"

NSString * const RNSwipeViewControllerLeftWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerLeftWillAppear";
NSString * const RNSwipeViewControllerLeftDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerLeftDidAppear";
NSString * const RNSwipeViewControllerRightWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerRightWillAppear";
NSString * const RNSwipeViewControllerRightDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerRightDidAppear";
NSString * const RNSwipeViewControllerBottomWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerBottomWillAppear";
NSString * const RNSwipeViewControllerBottomDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerBottomDidAppear";
NSString * const RNSwipeViewControllerCenterWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerCenterWillAppear";
NSString * const RNSwipeViewControllerCenterDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerCenterDidAppear";

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
    
    UITapGestureRecognizer *_tapGesture;
    
    CGRect _centerOriginal;

    CGRect _leftOriginal;
    CGRect _leftActive;
    CGRect _rightOriginal;
    CGRect _rightActive;
    CGRect _bottomOriginal;
    CGRect _bottomActive;
    
    CGPoint _centerLastPoint;
    
    BOOL _isAnimating;
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

// initial vars
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
    
    _isAnimating = NO;
}

#pragma mark - Viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect frame = self.view.bounds;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        frame = CGRectMake(0, 0, self.view.height, self.view.width);
    }
    
    _centerContainer = [[UIView alloc] initWithFrame:frame];
    _centerContainer.clipsToBounds = NO;
    _centerContainer.layer.masksToBounds = NO;
    
    _centerOriginal = _centerContainer.frame;
    _centerLastPoint = CGPointZero;
    
    _rightContainer = [[UIView alloc] initWithFrame:frame];
    _leftContainer = [[UIView alloc] initWithFrame:frame];
    _bottomContainer = [[UIView alloc] initWithFrame:frame];
    
    [self _layoutCenterContainer];
    [self _layoutRightContainer];
    [self _layoutLeftContainer];
    [self _layoutBottomContainer];
    
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
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewWasTapped:)];
    _tapGesture.numberOfTapsRequired = 1;

    [self.view addGestureRecognizer:_panGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _layoutContainersAnimated:NO duration:0.f];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self _resizeForOrienation:toInterfaceOrientation];
}

#pragma mark - Public methods

- (void)showLeft {
    [self showLeftWithDuration:kRNSwipeDefaultDuration];
}

- (void)showLeftWithDuration:(NSTimeInterval)duration {
    if (self.leftViewController) {
        [self _sendCenterToPoint:CGPointMake(self.leftVisibleWidth, 0) panel:_leftContainer toPoint:_leftActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleLeft;
        
        if ([self.leftViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.leftViewController) changedPercentReveal:100];
        }
    }
}

- (void)showRight {
    [self showRightWithDuration:kRNSwipeDefaultDuration];
}

- (void)showRightWithDuration:(NSTimeInterval)duration {
    if (self.rightViewController) {
        [self _sendCenterToPoint:CGPointMake(-1 * self.rightVisibleWidth, 0) panel:_rightContainer toPoint:_rightActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleRight;
        
        if ([self.rightViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.rightViewController) changedPercentReveal:100];
        }
    }
}

- (void)showBottom {
    [self showBottomWithDuration:kRNSwipeDefaultDuration];
}

- (void)showBottomWithDuration:(NSTimeInterval)duration {
    if (self.bottomViewController) {
        [self _sendCenterToPoint:CGPointMake(0, -1 * self.bottomVisibleHeight) panel:_bottomContainer toPoint:_bottomActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleBottom;
        
        if ([self.bottomViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.bottomViewController) changedPercentReveal:100];
        }
    }
}

- (void)resetView {
    [self _layoutContainersAnimated:YES duration:kRNSwipeDefaultDuration];
}

#pragma mark - Layout

- (void)_layoutCenterContainer {    
    _centerOriginal = _centerContainer.bounds;
    _centerOriginal.origin = CGPointZero;
}

- (void)_layoutRightContainer {
    _rightContainer.width = _rightVisibleWidth;
    self.rightViewController.view.width = _rightContainer.width;
    
    _rightOriginal = _rightContainer.bounds;
    _rightOriginal.origin.x = _centerContainer.width;
    
    _rightActive = _rightOriginal;
    _rightActive.origin.x = _centerContainer.width - _rightActive.size.width;
}

- (void)_layoutLeftContainer {
    _leftContainer.width = self.leftVisibleWidth;
    self.leftViewController.view.width = _leftContainer.width;
    
    _leftOriginal = _leftContainer.bounds;
    _leftOriginal.origin.x = - _leftOriginal.size.width;
    
    _leftActive = _leftOriginal;
    _leftActive.origin = CGPointZero;
}

- (void)_layoutBottomContainer {
    _bottomContainer.height = self.bottomVisibleHeight;
    self.bottomViewController.view.height = _bottomContainer.height;
    
    _bottomOriginal = _bottomContainer.bounds;
    _bottomOriginal.origin.y = _centerContainer.height;
    
    _bottomActive = _bottomOriginal;
    _bottomActive.origin.y = _centerContainer.height - _bottomActive.size.height;
}

#pragma mark - Setters

- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (_centerViewController != centerViewController) {
        _centerViewController = centerViewController;
        
        [self addChildViewController:_centerViewController];
        
        [self _loadCenter];
        
        [_centerContainer addSubview:_fadeView];
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController != rightViewController) {
        rightViewController.view.frame = _rightContainer.bounds;
        _rightViewController = rightViewController;
        
        [self addChildViewController:_rightViewController];
        
        [self _loadRight];
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != leftViewController) {
        leftViewController.view.frame = _leftContainer.bounds;
        _leftViewController = leftViewController;
        
        [self addChildViewController:_leftViewController];
        
        [self _loadLeft];
    }
}

- (void)setBottomViewController:(UIViewController *)bottomViewController {
    if (_bottomViewController != bottomViewController) {
        bottomViewController.view.frame = _bottomContainer.bounds;
        _bottomViewController = bottomViewController;
        
        [self addChildViewController:_bottomViewController];
        
        [self _loadBottom];
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

// when we are toggled, add a tap gesture to the center view
- (void)setIsToggled:(BOOL)isToggled {
    if (isToggled) {
        [_centerContainer addGestureRecognizer:_tapGesture];
    }
    else {
        [_centerContainer removeGestureRecognizer:_tapGesture];
    }
    _isToggled = isToggled;
}

- (void)setLeftVisibleWidth:(CGFloat)leftVisibleWidth {
    if (_leftVisibleWidth != leftVisibleWidth) {
        _leftVisibleWidth = leftVisibleWidth;
        [self _layoutLeftContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
    }
}

- (void)setRightVisibleWidth:(CGFloat)rightVisibleWidth {
    if (_rightVisibleWidth != rightVisibleWidth) {
        _rightVisibleWidth = rightVisibleWidth;
        [self _layoutRightContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
    }
}

- (void)setBottomVisibleHeight:(CGFloat)bottomVisibleHeight {
    if (_bottomVisibleHeight != bottomVisibleHeight) {
        _bottomVisibleHeight = bottomVisibleHeight;
        [self _layoutBottomContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
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

#pragma mark - Private Helpers

- (void)_resizeForOrienation:(UIInterfaceOrientation)orientation {
    CGSize sizeOriented = [UIApplication sizeInOrientation:orientation];
    
    CGRect centerFrame = _centerContainer.frame;
    centerFrame.size = sizeOriented;
    _centerContainer.frame = centerFrame;
    centerFrame.origin = CGPointZero;
    self.centerViewController.view.frame = centerFrame;
    [_centerContainer layoutSubviews];
    
    [self _layoutCenterContainer];
    
    _fadeView.frame = centerFrame;
    
    self.view.frame = centerFrame;
    
    if (self.leftViewController) {
        CGRect leftFrame = _leftContainer.frame;
        leftFrame.size.height = sizeOriented.height;
        leftFrame.size.width = self.leftVisibleWidth;
        _leftContainer.frame = leftFrame;
        leftFrame.origin = CGPointZero;
        self.leftViewController.view.frame = leftFrame;
        [_leftContainer layoutSubviews];
        
        [self _layoutLeftContainer];
    }
    
    if (self.rightViewController) {
        CGRect rightFrame = _rightContainer.frame;
        rightFrame.size.height = sizeOriented.height;
        rightFrame.size.width = self.rightVisibleWidth;
        _rightContainer.frame = rightFrame;
        rightFrame.origin = CGPointZero;
        self.rightViewController.view.frame = rightFrame;
        [_rightContainer layoutSubviews];
        
        [self _layoutRightContainer];
    }
    
    if (self.bottomViewController) {
        CGRect bottomFrame = _bottomContainer.frame;
        bottomFrame.size.height = self.bottomVisibleHeight;
        bottomFrame.size.width = sizeOriented.width;
        _bottomContainer.frame = bottomFrame;
        bottomFrame.origin = CGPointZero;
        self.bottomViewController.view.frame = bottomFrame;
        [_bottomContainer layoutSubviews];
        
        [self _layoutBottomContainer];
    }
    
    [self resetView];
}

- (void)_layoutContainersAnimated:(BOOL)animate duration:(NSTimeInterval)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerCenterWillAppear object:nil];
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeController:willShowController:)]) {
        [self.swipeDelegate swipeController:self willShowController:self.centerViewController];
    }
    
    [self.centerViewController viewWillAppear:animate];
    
    void (^block)(void) = [self _toResetContainers];
    
    if (animate) {
        _fadeView.hidden = NO;
        [UIView animateWithDuration:duration
                              delay:0
                            options:kNilOptions
                         animations:block
                         completion:^(BOOL finished){
                             if (finished) {
                                  self.isToggled = NO;
                                 
                                 [self.centerViewController viewDidAppear:animate];
                                 
                                 _isAnimating = NO;
                                 _centerLastPoint = CGPointZero;
                                 _fadeView.hidden = YES;
                                 _activeContainer = _centerContainer;
                                 
                                 self.visibleState = RNSwipeVisibleCenter;
                                 
                                 if ([self.leftViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                                     [((id<RNRevealViewControllerProtocol>)self.leftViewController) changedPercentReveal:0];
                                 }
                                 if ([self.rightViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                                     [((id<RNRevealViewControllerProtocol>)self.rightViewController) changedPercentReveal:0];
                                 }
                                 if ([self.bottomViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                                     [((id<RNRevealViewControllerProtocol>)self.bottomViewController) changedPercentReveal:0];
                                 }
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerCenterDidAppear object:nil];
                                 if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeController:didShowController:)]) {
                                     [self.swipeDelegate swipeController:self didShowController:self.centerViewController];
                                 }
                             }
                         }];
    }
    else {
        _fadeView.hidden = YES;
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

- (CGFloat)_remainingDuration:(CGFloat)position threshold:(CGFloat)threshold {
    CGFloat maxDuration = kRNSwipeDefaultDuration;
    threshold /= 2.f;
    CGFloat suggestedDuration = maxDuration * (position / (CGFloat)threshold);
    if (suggestedDuration < 0.05f) {
        return 0.05f;
    }
    if (suggestedDuration < maxDuration) {
        return suggestedDuration;
    }
    return maxDuration;
}

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
    if (self.canShowRight == NO && _centerContainer.left == 0) {
        return 0.f;
    }
    
    CGFloat translationTotal = translation + _centerLastPoint.x;
    if (translationTotal < - self.rightVisibleWidth) {
        CGFloat offset = translationTotal + self.rightVisibleWidth;
        translationTotal = self.rightVisibleWidth - offset / 15;
        translationTotal *= -1;
    }
    
    return translationTotal;
}

- (CGFloat)_filterRight:(CGFloat)translation {
    if (self.canShowLeft == NO && _centerContainer.left == 0) {
        return 0.f;
    }
    
    CGFloat translationTotal = translation + _centerLastPoint.x;
    if (translationTotal > self.leftVisibleWidth) {
        CGFloat offset = translationTotal - self.leftVisibleWidth;
        translationTotal = self.leftVisibleWidth + offset / 15;
    }
    
    return translationTotal;
}

- (CGFloat)_filterBottom:(CGFloat)translation {
    if (! self.canShowBottom) {
        return 0.f;
    }
    
    if (fabsf(_centerContainer.top) >= self.bottomVisibleHeight) {
        return self.bottomVisibleHeight * -1;
    }
    return translation + _centerLastPoint.y;
}

- (void)_sendCenterToPoint:(CGPoint)centerPoint panel:(UIView*)container toPoint:(CGPoint)containerPoint duration:(NSTimeInterval)duration {
    _fadeView.hidden = NO;
    
    [self.visibleController viewWillAppear:YES];
    [self.centerViewController viewWillDisappear:YES];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         _centerContainer.origin = centerPoint;
                         container.origin = containerPoint;
                         _fadeView.alpha = kRNSwipeMaxFadeOpacity;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _isAnimating = NO;
                             _centerLastPoint = _centerContainer.origin;
                             _activeContainer.layer.shouldRasterize = NO;
                             self.isToggled = YES;
                             
                             [self.visibleController viewDidAppear:YES];
                             [self.centerViewController viewDidDisappear:YES];
                             
                             NSString *notificationKey = nil;
                             UIViewController *controller = nil;
                             if (_activeContainer == _centerContainer) {
                                 notificationKey = RNSwipeViewControllerCenterDidAppear;
                                 controller = self.centerViewController;
                             }
                             else if (_activeContainer == _leftContainer) {
                                 notificationKey = RNSwipeViewControllerLeftDidAppear;
                                 controller = self.rightViewController;
                             }
                             else if (_activeContainer == _rightContainer) {
                                 notificationKey = RNSwipeViewControllerRightDidAppear;
                                 controller = self.rightViewController;
                             }
                             else if (_activeContainer == _bottomContainer) {
                                 notificationKey = RNSwipeViewControllerBottomDidAppear;
                                 controller = self.bottomViewController;
                             }
                             if (notificationKey) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:notificationKey object:nil];
                             }
                             if (controller &&
                                 self.swipeDelegate &&
                                 [self.swipeDelegate respondsToSelector:@selector(swipeController:didShowController:)]) {
                                 [self.swipeDelegate swipeController:self didShowController:controller];
                             }
                         }
                     }];
}


#pragma mark - Gesture delegate

- (BOOL)gestureRecognizerShouldBegin:(RNDirectionPanGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - Gesture handler

- (void)_handlePan:(RNDirectionPanGestureRecognizer*)recognizer {
    // beginning a pan gesture
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self _handleBegin:recognizer];
    }
    
    // changing a pan gesture
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self _handleChanged:recognizer];
    }

    // ending a pan gesture
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self _handleEnded:recognizer];
    }
}

- (void)_handleBegin:(RNDirectionPanGestureRecognizer*)recognizer {
    _activeDirection = recognizer.direction;
    
    _isAnimating = YES;
    
    switch (_activeDirection) {
        case RNDirectionLeft: {
            _activeContainer = _rightContainer;
            
            if (self.visibleState == RNSwipeVisibleCenter) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerLeftWillAppear object:nil];
                
                if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeController:willShowController:)]) {
                    [self.swipeDelegate swipeController:self willShowController:self.leftViewController];
                }
            }
        }
            break;
        case RNDirectionRight: {
            _activeContainer = _leftContainer;
            
            if (self.visibleState == RNSwipeVisibleCenter) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerRightWillAppear object:nil];
                
                if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeController:willShowController:)]) {
                    [self.swipeDelegate swipeController:self willShowController:self.rightViewController];
                }
            }
        }
            break;
        case RNDirectionDown:
        case RNDirectionUp: {
            _activeContainer = _bottomContainer;
            
            if (self.visibleState == RNSwipeVisibleCenter) {
                [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerBottomWillAppear object:nil];
                
                if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeController:willShowController:)]) {
                    [self.swipeDelegate swipeController:self willShowController:self.bottomViewController];
                }
            }
        }
            break;
    }
    
    // add shadow to active layer
    // could already be there if layer was visible
    _activeContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    _activeContainer.layer.shadowRadius = 5.f;
    _activeContainer.layer.shadowOffset = CGSizeZero;
    _activeContainer.layer.shadowOpacity = 0.5f;
    
    // turn ON rasterizing for scrolling performance
    _activeContainer.layer.shouldRasterize = YES;
    
    // ensure fadeing view is visible
    _fadeView.hidden = NO;
}

- (void)_handleChanged:(RNDirectionPanGestureRecognizer*)recognizer {
    CGPoint translate = [recognizer translationInView:_centerContainer];
    
    switch (_activeDirection) {
        case RNDirectionLeft:
        case RNDirectionRight: {
            if (self.visibleState != RNSwipeVisibleBottom) {
                CGFloat left = 0;
                if (recognizer.direction == RNDirectionLeft) {
                    left = [self _filterLeft:translate.x];
                }
                else {
                    left = [self _filterRight:translate.x];
                }
                
                _centerContainer.left = left;
                _rightContainer.left = _centerContainer.right;
                _leftContainer.right= _centerContainer.left;
                
                if (_centerContainer.left < 0) {
                    NSInteger percent = MIN(fabsf(left / self.rightVisibleWidth) * 100, 100);
                    if ([self.rightViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                        [((id<RNRevealViewControllerProtocol>)self.rightViewController) changedPercentReveal:percent];
                    }
                }
                else {
                    NSInteger percent = MIN(fabsf(left / self.leftVisibleWidth) * 100, 100);
                    if ([self.leftViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                        [((id<RNRevealViewControllerProtocol>)self.leftViewController) changedPercentReveal:percent];
                    }
                }
            }
        }
            break;
        case RNDirectionDown: {
            if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                _centerContainer.top = [self _filterTop:translate.y];
                _activeContainer.top = _bottomOriginal.origin.y + [self _filterTop:translate.y];
                
                NSInteger percent = MIN(fabsf(_centerContainer.top / self.bottomVisibleHeight) * 100, 100);
                if ([self.bottomViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                    [((id<RNRevealViewControllerProtocol>)self.bottomViewController) changedPercentReveal:percent];
                }
            }
        }
            break;
        case RNDirectionUp: {
            if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                _centerContainer.top = [self _filterBottom:translate.y];
                _activeContainer.top = _bottomOriginal.origin.y + [self _filterBottom:translate.y];
                
                NSInteger percent = MIN(fabsf(_centerContainer.top / self.bottomVisibleHeight) * 100, 100);
                if ([self.bottomViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
                    [((id<RNRevealViewControllerProtocol>)self.bottomViewController) changedPercentReveal:percent];
                }
            }
        }
            break;
    }
    
    // calculate the amount of fading
    // max static var defined as kRNSwipeMaxFadeOpacity
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
    // max value is kRNSwipeMaxFadeOpacity, caluclation isn't perfect but i dont care
    CGFloat alpha = kRNSwipeMaxFadeOpacity * (position / (CGFloat)threshold);
    if (alpha > kRNSwipeMaxFadeOpacity) alpha = kRNSwipeMaxFadeOpacity;
    _fadeView.alpha = alpha;
}

- (void)_handleEnded:(RNDirectionPanGestureRecognizer*)recognizer {
    if (_centerContainer.left > self.leftVisibleWidth / 2.f) {
        // left will be shown
        CGFloat duration = [self _remainingDuration:abs(_centerContainer.left) threshold:self.leftVisibleWidth];
        [self _sendCenterToPoint:CGPointMake(self.leftVisibleWidth, 0) panel:_leftContainer toPoint:_leftActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleLeft;
        
        if ([self.leftViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.leftViewController) changedPercentReveal:100];
        }
    }
    else if (_centerContainer.left < (self.rightVisibleWidth / -2.f)) {
        // right will be shown
        CGFloat duration = [self _remainingDuration:abs(_centerContainer.left) threshold:self.rightVisibleWidth];
        [self _sendCenterToPoint:CGPointMake(-1 * self.rightVisibleWidth, 0) panel:_rightContainer toPoint:_rightActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleRight;
        
        if ([self.rightViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.rightViewController) changedPercentReveal:100];
        }
    }
    else if (_centerContainer.top < self.bottomVisibleHeight / -2.f) {
        // bottom will be shown
        CGFloat duration = [self _remainingDuration:abs(_centerContainer.top) threshold:self.bottomVisibleHeight];
        [self _sendCenterToPoint:CGPointMake(0, -1 * self.bottomVisibleHeight) panel:_bottomContainer toPoint:_bottomActive.origin duration:duration];
        self.visibleState = RNSwipeVisibleBottom;
        
        if ([self.bottomViewController conformsToProtocol:@protocol(RNRevealViewControllerProtocol)]) {
            [((id<RNRevealViewControllerProtocol>)self.bottomViewController) changedPercentReveal:100];
        }
    }
    else {
        // not enough visible area, clear the scene
        CGFloat position = _centerContainer.left == 0.f ? abs(_centerContainer.top) : abs(_centerContainer.left);
        CGFloat threshold = _centerContainer.left == 0.f ? self.bottomVisibleHeight : self.leftVisibleWidth;
        CGFloat duration = [self _remainingDuration:position threshold:threshold];
        [self _layoutContainersAnimated:YES duration:duration];
        self.visibleState = RNSwipeVisibleCenter;
    }
}

#pragma mark - Tap Gesture

- (void)centerViewWasTapped:(UITapGestureRecognizer*)recognizer {
    [self _layoutContainersAnimated:YES duration:kRNSwipeDefaultDuration];
}

@end
