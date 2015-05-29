//
//  RadioCell.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "RadioCell.h"

@implementation RadioCell

- (void)awakeFromNib
{
    // Initialization code
    self.switchButton.on = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onSwitch:(id)sender
{
    if (nil != self.observer) {
        [self.observer update:self value:self.switchButton];
    }
}

-(IBAction)onClick:(id)sender
{
    if (nil != self.observer) {
        [self.observer update:self value:self.button];
    }
}
@end
