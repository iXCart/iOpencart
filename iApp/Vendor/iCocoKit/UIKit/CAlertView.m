//
//  CAlertView.m
//  iApp
//
//  Created by icoco7 on 6/14/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CAlertView.h"

@implementation CAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)hide
{
    [self  dismissWithClickedButtonIndex:self.cancelButtonIndex animated: true];
}

@end
