//
//  RNLeftViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 11/2/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNLeftViewController.h"

@interface RNLeftViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end

@implementation RNLeftViewController

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
    NSLog(@"left view did load");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"left view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"left view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"left view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"left view did disappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changedPercentReveal:(NSInteger)percent {
    self.progressBar.progress = percent / 100.f;
}

@end
