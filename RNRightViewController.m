//
//  RNRightViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 2/22/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import "RNRightViewController.h"
#import "UIView+Sizes.h"

@interface RNRightViewController ()
@property (weak, nonatomic) IBOutlet UIView *animateView;

@end

@implementation RNRightViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changedPercentReveal:(NSInteger)percent {
    NSLog(@"Right: %i",percent);
    
    if (percent == 100) {
        [UIView animateWithDuration:0.1f
                              delay:0
                            options:0
                         animations:^{
                             self.animateView.top = percent - 100;
                         }
                         completion:NULL];
    }
    else {
        self.animateView.top = percent - 100;
    }
}

@end
