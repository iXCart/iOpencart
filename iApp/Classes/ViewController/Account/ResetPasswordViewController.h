//
//  ResetPasswordViewController.h
//  iApp
//
//  Created by icoco7 on 12/12/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "AppViewController.h"

@interface ResetPasswordViewController : AppViewController

@property(nonatomic)IBOutlet UITextField* emailField;
@property(nonatomic)IBOutlet UIButton* continueButton;

- (IBAction)onSubmit:(id)sender;

@end
