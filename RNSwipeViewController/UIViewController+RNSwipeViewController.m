//
//  UIViewController+RNSwipeViewController.m
//  RNSwipeViewController
//
//  Created by Ryan Nystrom on 11/2/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "UIViewController+RNSwipeViewController.h"

@implementation UIViewController (RNSwipeViewController)

- (RNSwipeViewController *)swipeController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RNSwipeViewController class]]) {
            return (RNSwipeViewController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
