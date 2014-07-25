//
//  CategoriesViewController.h
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppTableViewController.h"

@interface CategoriesViewController : AppTableViewController <UISearchBarDelegate>
{
   
    
}

@property(nonatomic)IBOutlet UISearchBar* searchBar;
@end
