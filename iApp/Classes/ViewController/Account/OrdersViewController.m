//
//  OrdersViewController.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import "OrdersViewController.h"
#import "XCartDataManager.h"
#import "SVPullToRefresh.h"
#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
#import "OrderCell.h"
@interface OrdersViewController ()

@end

static NSString* ruseCellId = @"OrderCell";

@implementation OrdersViewController

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
    UINib *nib = [UINib nibWithNibName:ruseCellId bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:ruseCellId];
  

    
   // self.tableView.tableHeaderView = self.searchBar;
    UIEdgeInsets inset = UIEdgeInsetsMake(44+20, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString2(@"Order history", @"Order history");
    [self prepareTableview];
   // [[XCartDataManager sharedManager] getCategories  ];
   // [self loadData];
    
    [self hookPullDownRefresh];
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchData:(NSDictionary*) parmas
{
    if (nil == parmas || [parmas count]<=0) {
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parmas];
    [params setValue:TRUE_ONE forKey:Rest_json];
    
    NSString* urlString = [Resource getOrderHistoryURLString];
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //@step
        RKMappingResult* rkResult =  [Resource parseData2Result:operation.HTTPRequestOperation.responseData];
        NSArray* list  = [[rkResult dictionary] valueForKey :@"orders"] ;
        NSDictionary* dict =[NSDictionary dictionaryWithObjects:list forKeys:list];
        //@step
        RKMappingResult* result = [[RKMappingResult alloc]initWithDictionary:dict];

        _mappingResult = result;
        
        //@step
        [self.tableView reloadData];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString* buf = operation.HTTPRequestOperation.responseString;
        [CDialogViewManager showMessageView:[error localizedDescription] message:buf delayAutoHide: 3];
        //@step
        _mappingResult = nil;
        //@step
        [self.tableView reloadData];
        //@step
    }];
    
}


- (void)loadData
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:@"1", _Meta_page,nil];
 
    __weak OrdersViewController *weakSelf = self;
    NSString* urlString = [Resource getOrderHistoryURLString];
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        RKMappingResult* rkResult =  [Resource parseData2Result:operation.HTTPRequestOperation.responseData];
        NSArray* list  = [[rkResult dictionary] valueForKey :@"orders"] ;
        NSDictionary* dict =[NSDictionary dictionaryWithObjects:list forKeys:list];
        //@step
        RKMappingResult* result = [[RKMappingResult alloc]initWithDictionary:dict];
        
        _mappingResult = result;
    
        //@step
        [weakSelf.tableView reloadData];
        
        [weakSelf stopPullToRefreshAnimation];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        [weakSelf stopPullToRefreshAnimation];
    }];

}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 86;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [_mappingResult count];;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    NSString* reuseId =ruseCellId;
     
     OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
   //
     NSArray* items = [_mappingResult array];
     int row = indexPath.row;
     NSDictionary* item = [items objectAtIndex:row];
     cell.labelOrderID.text = [item valueForKey:@"order_id"];
     cell.labelProducts.text = [Lang safeNumberToIntString:[item valueForKey:@"products"] toValue:@""] ;
     
     cell.labelStatus.text = [item valueForKey:@"status"];
     cell.labelTotal.text =  [item valueForKey:@"total"];
    
     
     return cell;
 }



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* items = [_mappingResult array];
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    
    AppViewController* viewController = nil;
    if ([item isKindOfClass:[NSManagedObject class]]) {
        viewController = [ProductsViewController create];
        viewController.args = item;

    }
    else
    {
        NSString* product_id = (NSString*) [item objectForKey: Product_product_id];
        if (![Lang isEmptyString:product_id]) {
            viewController = [ProductDetailViewController create];
            viewController.args = item;
         }
    }
         
    [self.navigationController pushViewController:viewController animated:true];
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton= true;
    return  true;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
    searchBar.showsCancelButton = false;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    
    NSString* keywords =  searchBar.text ;
    if ([Lang isEmptyString:keywords]) {
        [searchBar resignFirstResponder];
        [self loadData];
        return;
    }
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            keywords, @"search",nil];
    
    [self searchData:params];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
    //[self loadData];
}

#pragma mark pull to refresh 
- (void)hookPullDownRefresh
{
    __weak OrdersViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf  loadData];
    }];
    
    [self.tableView.pullToRefreshView  setTitle:NSLocalizedString(@"Release to load all data...",@"") forState:(SVPullToRefreshStateTriggered)] ;
    
    self.tableView.pullToRefreshView.arrowColor = [UIColor grayColor];
}

-(void)stopPullToRefreshAnimation
{
    
    [self.tableView.pullToRefreshView stopAnimating]; // call to stop animation
    return;
    UIEdgeInsets inset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}
@end
