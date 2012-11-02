//
//  RNToolsViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 11/2/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNToolsViewController.h"
#import "UIViewController+RNSwipeViewController.h"
#import "RNSwipeViewController.h"

@interface RNToolsViewController ()

@end

@implementation RNToolsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleLeft:(id)sender {
    if (! self.swipeController) {
        NSLog(@"swipe controller not found");
    }
    [self.swipeController showLeft];
}

- (IBAction)toggleRight:(id)sender {
    [self.swipeController showRight];
}

- (IBAction)toggleBottom:(id)sender {
    [self.swipeController showBottom];
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider*)sender;
    self.swipeController.bottomVisibleHeight = slider.value;
}

@end
