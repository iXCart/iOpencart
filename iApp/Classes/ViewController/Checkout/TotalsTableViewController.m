//
//  TotalsTableViewController.m
//  iApp
//
//  Created by icoco7 on 7/16/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "TotalsTableViewController.h"

@interface TotalsTableViewController ()

@end

@implementation TotalsTableViewController


-(void)prepareTableview
{
    UINib *nib = [UINib nibWithNibName:@"BaseCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"BaseCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self prepareTableview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)relaod:(NSArray*)list
{
    _list = list;
    if (nil == _list) {
        _list = [NSArray array];
    }
    [self.tableView reloadData];
    
    //@step
    int count = [_list count];
    CGFloat  height =  count >0 ? 44 * count : 0; //@ 44 is default row height;
    
    CGRect frame = self.view.frame;
    frame.size.height = height;
    
    self.view.frame = frame;
    self.tableView.frame = frame;
    [self.view setNeedsLayout];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     // Return the number of rows in the section.
    return [_list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
    
    
    int row = indexPath.row;
    NSDictionary* item = [_list objectAtIndex:row];
    
    NSString* title = [item valueForKey:_Meta_title];
    NSString* text = [item valueForKey:_Meta_text];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = text;
    return cell;
}
 

@end
