RNSwipeViewController
=======

Seemlessly integrate beautifully functional view controllers into your app that are accessible with just the swipe of a finger. Inspiration for this project came from [David Smith](http://david-smith.org) and his gorgeous app [Check The Weather](http://checktheweather.co). 

iPad support added along with example on 11/8/12.

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

#### Setup in Code

If you want to avoid Storyboards (I don't blame you), you can setup everything in code. Here is an example from the AppDelegate of a  app of mine.

``` objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // PTMasterController is a subclass of RNSwipeViewController
    PTMasterController *masterController = [[PTMasterController alloc] init];
 
    PTSchemeController *scheme = [[PTSchemeController alloc] init];
    PTUtilityController *utility = [[PTUtilityController alloc] init];
    PTWritingController *writing = [[PTWritingController alloc] init];
    
    masterController.centerViewController = writing;
    masterController.rightViewController = utility;
    masterController.leftViewController = scheme;
    
    masterController.leftVisibleWidth = kGridSize + 3 * kPadding;
    masterController.rightVisibleWidth = kGridSize * 2 + 3 * kPadding;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
    self.window.rootViewController = masterController;
 
    self.window.backgroundColor = [UIColor underPageBackgroundColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
```

## Performance ##

Expect *decent* performance on the iPhone 4 or later. However on newer devices (4S+) you should expect 60fps.

## Config ##

<img src="https://github.com/rnystrom/RNSwipeViewController/blob/master/images/dimensions.jpg?raw=true" />

<img src="https://github.com/rnystrom/RNSwipeViewController/blob/master/images/landscape.jpg?raw=true" />

You can customize the width of each view controller's panel at run-time. Make sure the views in your view controllers are prepared to be smaller than your device's width/height.

``` objective-c
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

## Percent Protocol ##

#### New Feature

Your left, right, and bottom view controllers can optionally conform to the <code>RNRevealViewControllerProtocol</code> protocol in order to receive updates on how far the view controller is presented. The percent is an integer 0 to 100. The only method this protocol uses is:

``` objective-c
- (void)changedPercentReveal:(NSInteger)percent;
```

The example updates views in the left and right controller.

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

## Apps

If you've used this project in a live app, please <a href="mailTo:rnystrom@whoisryannystrom.com">let me know</a>! Nothing makes me happier than seeing someone else take my work and go wild with it.

* [Poetreat](https://itunes.apple.com/us/app/poetreat-write-quick-simple/id636392647?ls=1&mt=8)
* [WeatherFy](https://itunes.apple.com/us/app/weatherfy/id588926390?mt=8&ign-mpt=uo%3D4)

## Contact ##

* [@nystrorm](https://twitter.com/_ryannystrom) on Twitter
* [@rnystrom](https://github.com/rnystrom) on Github
* <a href="mailTo:rnystrom@whoisryannystrom.com">rnystrom [at] whoisryannystrom [dot] com</a>

## License ##

See [LICENSE](https://raw.github.com/rnystrom/RNSwipeViewController/0.1.0/LICENSE)
