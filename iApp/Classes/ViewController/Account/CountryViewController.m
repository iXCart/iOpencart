//
//  CountryViewController.m
//  iApp
//
//  Created by icoco7 on 12/1/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CountryViewController.h"
#import "XCartDataManager.h"
#import "StateViewController.h"

@interface CountryViewController ()
{
    NSIndexPath* _selectedIndexPath;
    
    NSArray* _list;
}
@end

static NSString*  _reuseId = @"UITableViewCell";

@implementation CountryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareTableview
{
    //UINib *nib = [UINib nibWithNibName:_reuseId bundle:nil];
    
    [self.tableView registerClass:[ UITableViewCell class]
         forCellReuseIdentifier:_reuseId] ;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Countries");
    
    [self prepareTableview];
    
    
}

- (void)renderToolBar:(BOOL)visiable
{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
}


#pragma mark data routine

#pragma loadData
- (void)loadData
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"query_country",nil];
    
    
    NSString* urlString = [Resource getCountriesURLString];
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [Resource parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        _list = [_mappingResult array];
        
        //@step
        [self.tableView reloadData];
        //@step
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_list count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =_reuseId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId ];
    //[[CartItemCell alloc]initWithFrame:CGRectZero];
    //
    NSArray* items = _list;
    
    NSInteger row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
   
    cell.textLabel.text = [item valueForKey:@"name"];
    
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        cell.imageView.image = [UIImage imageNamed:@"row_selected.png"];
    }else
        cell.imageView.image  = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( [indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        [self setSelectIndexPath:nil];
    }else{
        [self setSelectIndexPath:indexPath];
    }
    
    //@step
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView  reloadSections:set  withRowAnimation:UITableViewRowAnimationFade];
    
    
}


#pragma upate next button 
- (void)setSelectIndexPath:(NSIndexPath*)indexPath
{
    _selectedIndexPath = indexPath;
    if (nil != _selectedIndexPath )
    {
        NSArray* items = _list;
        NSInteger row = _selectedIndexPath.row;
        NSDictionary* item = [items objectAtIndex:row];
        //@step
        NSMutableDictionary* args = [NSMutableDictionary dictionaryWithDictionary:item];
        self.args = args ;
        
        //@step
        StateViewController * viewController = (StateViewController*)[CUIEnginer createViewController:@"StateViewController" inNavigationController:false];
        //@step
        viewController.args = self.args;
         
        [self.navigationController pushViewController: viewController animated:YES];
    }
}


@end
