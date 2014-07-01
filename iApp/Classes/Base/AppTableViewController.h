//
//  AppTableViewController.h
//  iApp
//
//  Created by icoco7 on 6/12/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "AppViewController.h"

@interface AppTableViewController : AppViewController<UITableViewDataSource,UITableViewDelegate>
{
      RKMappingResult* _mappingResult;
}
@property(nonatomic,strong)IBOutlet UITableView* tableView;

@end
