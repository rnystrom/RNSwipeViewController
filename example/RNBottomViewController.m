//
//  RNBottomViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 2/22/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import "RNBottomViewController.h"

@interface RNBottomViewController ()

@end

@implementation RNBottomViewController

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

- (void)changedPercentReveal:(NSInteger)percent {
    NSLog(@"Bottom: %i",percent);
}

@end
