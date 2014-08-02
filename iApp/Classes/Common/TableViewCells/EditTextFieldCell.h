//
//  EditTextFieldCell.h
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"
#import "JVFloatLabeledTextField.h"
@interface EditTextFieldCell : CTableViewCell <UITextFieldDelegate>

@property(nonatomic) JVFloatLabeledTextField* textField;
 
@property(nonatomic) id <ObserverDelegate>observer;
@end
