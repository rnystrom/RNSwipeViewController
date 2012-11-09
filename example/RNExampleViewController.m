//
//  RNExampleViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 10/31/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNExampleViewController.h"

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface RNExampleViewController ()

@end

@implementation RNExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];
    self.bottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bottomViewController"];
    
    if (IS_IPAD) {
        self.leftVisibleWidth = 500;
        self.rightVisibleWidth = 300;
        self.bottomVisibleHeight = 500;
    }
    
    self.swipeDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Swipe delegate

- (void)swipeController:(RNSwipeViewController *)swipeController willShowController:(UIViewController *)controller {
    NSLog(@"will show");
}

- (void)swipeController:(RNSwipeViewController *)swipeController didShowController:(UIViewController *)controller {
    NSLog(@"did show");
}

@end
