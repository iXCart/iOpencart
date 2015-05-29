//
//  RegisterViewController.h
//  iApp
//
//  Created by icoco7 on 11/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "AppTableViewController.h"

@interface RegisterViewController : AppTableViewController <UITextFieldDelegate,ObserverDelegate>
{
     
}

- (void)updateCountryStateFields;

@end
