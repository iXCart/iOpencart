//
//  PaymentMethodViewController.h
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "AppTableViewController.h"

@interface PaymentMethodViewController : AppTableViewController
{
    NSArray* _list;
}

@property(nonatomic)IBOutlet UIView* bottomView;
@property(nonatomic)IBOutlet UIView* commentContainerView;
@property(nonatomic)IBOutlet UITextView* commentView;

@property(nonatomic)IBOutlet UIView* agreeTermView;

@end
