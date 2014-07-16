//
//  ConfirmViewController.h
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppTableViewController.h"

@interface ConfirmViewController : AppTableViewController
{
    NSArray* _prodcuts;
}
@property(nonatomic)IBOutlet UIView* bottomView;

@property(nonatomic)IBOutlet UILabel* labelSubTotal;
@property(nonatomic)IBOutlet UILabel* labelEcoTax;
@property(nonatomic)IBOutlet UILabel* labelVAT;
@property(nonatomic)IBOutlet UILabel* labelTotal;

@end
