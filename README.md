RNSwipeViewController
=======

Seemlessly integrate beautifully functional view controllers into your app that are accessible with just the swipe of a finger. Inspiration for this project came from [David Smith](http://david-smith.org) and his gorgeous app [Check The Weather](http://checktheweather.co). 

Note: As of now, RNSwipeViewController is intended for use with portrait orientation on iPhone/iPod only.

#### [View the Docs](http://rnystrom.github.com/RNSwipeViewController/index.html) ####

[Check out the Demo](http://www.youtube.com/watch?v=5Un5OesiJW8&feature=youtu.be) *Excuse the graphics glitches.*

## Installation ##

Drag the included <code>RNSwipeViewController</code> folder into your project. Then, include the following frameworks under *Link Binary With Libraries*:

* QuartzCore.framework

That's it.

## Usage ##

In the provided example, I have a swipe controller setup via Storyboards. However, you should be able to create your controllers with NIBs or plain code. Using the swipe controller is similar to using a <code>UINavigationController</code> in that [RNSwipeViewController](http://rnystrom.github.com/RNSwipeViewController/Classes/RNSwipeViewController.html) is a *container* of child view controllers. All interaction logic is controlled with the swipe controller. All of your app's logic should be contained in your child view controllers.

I would also recommend subclassing [RNSwipeViewController](http://rnystrom.github.com/RNSwipeViewController/Classes/RNSwipeViewController.html) like I've done in the example. However, you shouldn't have to.

Create view controllers as you deem necessary and assign them to the swipe controller's respective sides. [RNSwipeViewController](http://rnystrom.github.com/RNSwipeViewController/Classes/RNSwipeViewController.html) will handle enabling/disabling of gestures for you.

``` objective-c
self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
self.bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bottomViewController"];
```

With minimal effort, your views are now setup.

## Config ##

<img src="https://github.com/rnystrom/RNSwipeViewController/blob/master/images/dimensions.jpg?raw=true" />

You can customize the width of each view controller's panel at run-time. Make sure the views in your view controllers are prepared to be smaller than your device's width/height.

``` obejctive-c
@property (assign, nonatomic) CGFloat leftVisibleWidth;     // default 200
@property (assign, nonatomic) CGFloat rightVisibleWidth;    // default 200
@property (assign, nonatomic) CGFloat bottomVisibleHeight;  // default 300
```

## Categories (optional) ##

You can also include the helpful [UIViewController+RNSwipeViewController](http://rnystrom.github.com/RNSwipeViewController/Categories/UIViewController+RNSwipeViewController.html) category to make finding and using the swipe controller easier. Just import the .h/.m files into your controller and call the <code>swipeController</code> property.

``` objective-c
@implementation YourViewController

- (IBAction)toggleLeft:(id)sender {
    [self.swipeController showRight];
}

@end
```

## Delegation, Notification, and KVO ##

I've included some helpers in case you need to know when and what view controllers are showing (or hiding). Take a look at the [documentation](http://rnystrom.github.com/RNSwipeViewController/index.html) for help with the delegate. Below I've listed the available <code>NSNotificationCenter</code> keys.

``` objective-c
NSString * const RNSwipeViewControllerLeftWillAppear;
NSString * const RNSwipeViewControllerLeftDidAppear;
NSString * const RNSwipeViewControllerRightWillAppear;
NSString * const RNSwipeViewControllerRightDidAppear;
NSString * const RNSwipeViewControllerBottomWillAppear;
NSString * const RNSwipeViewControllerBottomDidAppear;
NSString * const RNSwipeViewControllerCenterWillAppear;
NSString * const RNSwipeViewControllerCenterDidAppear;
```

The only real KVO-purposed property in here is <code>isToggled</code>. If there is a need for more options I'll add them.

## Status ##

If you're interested in what your swipe controller looks like presently, you can ask the <code>visibleState</code> property what is showing. The possibilities are

``` objective-c
RNSwipeVisibleLeft
RNSwipeVisibleCenter
RNSwipeVisibleRight
RNSwipeVisibleBottom
```

Or, if you need to access the presented view controller directly, you can do so.

``` objective-c
UIViewController *visibleController = self.swipeController.visibleController;
```

## Contact ##

* [@nystrorm](https://twitter.com/nystrorm) on Twitter
* [@rnystrom](https://github.com/rnystrom) on Github
* <a href="mailTo:rnystrom@whoisryannystrom.com">rnystrom [at] whoisryannystrom [dot] com</a>

## License ##

Copyright (c) 2012 Ryan Nystrom (http://whoisryannystrom.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.