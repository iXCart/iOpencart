//
//  TotalsTableViewController.h
//  iApp
//
//  Created by icoco7 on 7/16/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppTableViewController.h"

@interface TotalsTableViewController : AppTableViewController
{
    NSArray* _list;

}
 
- (void)relaod:(NSArray*)list;

@end
