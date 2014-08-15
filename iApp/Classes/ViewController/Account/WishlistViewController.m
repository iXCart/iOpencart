//
//  WishlistViewController.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "WishlistViewController.h"
#import "DataModel.h"
#import "ProductDetailViewController.h"
#import "XCartDataManager.h"
#import "ProductItemCell.h"
#import "PaymentAddressViewController.h"
#import "TotalsTableViewController.h"

@interface WishlistViewController ()
{
    
}
@end

static NSString*  _reuseId = @"ProductItemCell";

@implementation WishlistViewController

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
    UINib *nib = [UINib nibWithNibName:_reuseId bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:_reuseId];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"WishList");
    
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
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    
    NSString* urlString = [Resource getAccountWishlistURLString];
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [Resource parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        _prodcuts = [_mappingResult array];
        
        //@step
        [self.tableView reloadData];
        //@step
 
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];

}

#pragma mark data routine loadData
- (void)removeProduct:(NSDictionary*)item
{
    [[DataModel sharedInstance]moveProuctFromCart:item];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 140;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_prodcuts count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =_reuseId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId ];
    //[[CartItemCell alloc]initWithFrame:CGRectZero];
    //
    NSArray* items = _prodcuts;

    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    //cell.textLabel.text = [item valueForKey:Cart_Product_name];
    ProductItemCell* theCell = (ProductItemCell*)cell;
    
    [theCell setArgs:item];
    
    theCell.indexPath = indexPath;
    return cell;
}

- (void)removeRow:(UITableViewCell*)sender
{
    ProductItemCell* cell = (ProductItemCell*)sender;
    NSIndexPath* indexPath = cell.indexPath;
    NSMutableArray* items = (NSMutableArray*) _prodcuts;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    [self removeProduct:item];
    
    [items removeObjectAtIndex:row];
    
    // Delete the row from the data source
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* items = _prodcuts;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    AppViewController * viewController = [ProductDetailViewController create];
    viewController.args = item;
    
    [self.navigationController pushViewController:viewController animated:true];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray* items = (NSMutableArray*) _prodcuts;
        int row = indexPath.row;
        NSDictionary* item = [items objectAtIndex:row];
        
        [self removeProduct:item];
        
        [items removeObjectAtIndex:row];
        
        // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //@step
        [self setEditing:true animated:true];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



@end
