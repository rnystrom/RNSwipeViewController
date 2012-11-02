//
//  UIViewController+RNSwipeViewController.h
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 11/2/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSwipeViewController.h"

@class RNSwipeViewController;

@interface UIViewController (RNSwipeViewController)

@property (nonatomic, weak, readonly) RNSwipeViewController *swipeController;

@end
