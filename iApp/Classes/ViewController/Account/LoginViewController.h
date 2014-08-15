//
//  LoginViewController.h
//  iCart
//
//  Created by icoco7 on 5/21/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewController.h"

@interface LoginViewController : AppViewController <UITextFieldDelegate>

@property(nonatomic)IBOutlet UITextField* emailTextField;
@property(nonatomic)IBOutlet UITextField* passwordTextField;

@property(nonatomic)IBOutlet UIButton* loginButton;
@property(nonatomic)IBOutlet UIButton* forgotPasswordButton;
@property(nonatomic)IBOutlet UIButton* registerButton;

@end
