//
//  EditTextFieldCell.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "EditTextFieldCell.h"

@implementation EditTextFieldCell

- (void)awakeFromNib
{
    // Initialization code
    if (nil == self.textField) {
        self.textField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectZero];
        [self addSubview:self.textField];
        self.textField.delegate = self;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    CGRect frame = self.contentView.frame;
    frame.size.width = frame.size.width -15;
    frame.origin.x = 15;
    self.textField.frame = frame;
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    //@step
    if (nil != self.observer) {
        [self.observer update:self value:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    NSDictionary* item = (NSDictionary*)_args;
    NSString* value =[Lang safeString:textField.text toValue:@""]  ;
    [item setValue:value forKey:@"value"];
    //@step
    if (nil != self.observer) {
        [self.observer update:self value:textField];
    }

}




-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
