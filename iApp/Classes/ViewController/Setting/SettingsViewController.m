//
//  SettingsViewController.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "XCartKit.h"
#import "DataModel.h"

@interface SettingsViewController ()

@end

static NSString* ruseCellId = @"BaseCell";
@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareTableview
{
    
    [self.tableView registerClass: [UITableViewCell class]
         forCellReuseIdentifier:ruseCellId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Settings");
    [self prepareTableview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    XCartUser* user = [XCartDataManager sharedInstance].activeUser;
    if (nil == user || ![user isValidateUser]) {
        LoginViewController* viewController = (LoginViewController*)[CUIEnginer createViewController:@"LoginViewController" inNavigationController:true];
        
         [self presentViewController:viewController animated:true completion:^{
             self.view.hidden = false;
         }];
        return;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //@step
    [self loadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*) loadDefs
{
    NSString* cfgFilePath =[Utils getBundleFileAsFullPath:  @"settingDefs.plist"];
    NSArray* data = [NSArray arrayWithContentsOfFile:cfgFilePath];
	if (nil == data || [data count]<=0) {
		NSLog(@"Miss read data from->[%@]", cfgFilePath);
		return nil;
	}
    NSLog(@"%@->loadDefs:[%@]",self, data);
    return data;
}

- (void)loadData
{
    _defs = [self loadDefs];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_defs count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =ruseCellId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
        //
    NSArray* items = _defs;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    cell.textLabel.text = [item valueForKey:@"name"];
    
    return cell;
}

- (void)processCommand:(NSDictionary*)dict
{
    NSString* class = (NSString*) [dict valueForKey:@"class"];
    if (StringEqual(class, @"Logout")) {
        
        [[DataModel sharedInstance]loutOut];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* items = _defs;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    [self processCommand:item];
    //@step
    //ProductsViewController* viewController = [[ProductsViewController alloc]initWithNibName:@"ProductsViewController" bundle:nil];
    
   // AppViewController * viewController = [ProductsViewController create];
   // viewController.args = item;
    
   // [self.navigationController pushViewController:viewController animated:true];
    
}

@end
