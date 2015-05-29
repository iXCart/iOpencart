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
    NSLog(@"textFieldDidBeginEditing->%@",textField);
    if (nil != self.observer) {
        //@step
       [self.observer update:self value: nil ];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    NSDictionary* item = (NSDictionary*)_args;
    NSString* value =[Lang safeString:textField.text toValue:@""]  ;
    NSLog(@"textFieldDidEndEditing->%@",item);
    if ([item isMemberOfClass:[NSMutableDictionary class]]) {
        [item setValue:value forKey:@"value"];
    }
  
    //@step
    if (nil != self.observer) {
        //@step
        NSString* name = [item valueForKey:@"name"];
      
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",value,@"value", nil];
        [self.observer update:self value: params ];
    }
    
     NSLog(@"textFieldDidEndEditing->%@",item);

}




-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
