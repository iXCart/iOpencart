//
//  CAnimator.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CAnimator.h"

@implementation CAnimator

+ (void)fadeView:(UIView*)targetView  completion:(void (^)(BOOL finished))completion
{
    
    void (^animations)() = ^() {
        
        [targetView removeFromSuperview];
        targetView.hidden = NO;
    };
    [UIView transitionWithView:targetView.superview
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseInOut
     | UIViewAnimationOptionTransitionCrossDissolve
     | UIViewAnimationOptionAllowAnimatedContent
                    animations:animations
                    completion:completion];
}
@end
