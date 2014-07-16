//
//  CartViewController.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CartViewController.h"
#import "DataModel.h"
#import "ProductDetailViewController.h"
#import "XCartDataManager.h"
#import "CartItemCell.h"
#import "PaymentAddressViewController.h"
#import "TotalsTableViewController.h"

@interface CartViewController ()
{
    TotalsTableViewController* _totalsController;
}
@end

@implementation CartViewController

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
    UINib *nib = [UINib nibWithNibName:@"CartItemCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"CartItemCell"];
    if (nil == _totalsController) {
        _totalsController = (TotalsTableViewController*) [TotalsTableViewController create];
    }
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Shopping Cart");
    
    [self prepareTableview];
   
    
}
- (void)renderToolBar:(BOOL)visiable
{
    if (visiable) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStylePlain target:self action:@selector(checkOut:)];
        [self.navigationItem setRightBarButtonItem:button];
    }else
        [self.navigationItem setRightBarButtonItem:nil];
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    
}

- (void)checkOut:(id)sender
{
    AppViewController * viewController = [PaymentAddressViewController create];
   // viewController.args = item;
    
    [self.navigationController pushViewController:viewController animated:true];

}

- (void)loadDataFromLocal
{
    NSArray* list = [[DataModel sharedInstance] getProudctsFromCart];
    if (nil == list) {
        _prodcuts = [NSArray array];
    }else
        _prodcuts = list;
    
    NSLog(@"%@->loadData:%@",self, _prodcuts);
    //@step
    [self.tableView reloadData];
}

- (void)renderTotalView:(NSDictionary*)record
{
    self.labelSubTotal.text =[record valueForKey:Cart_Product_name];
    self.labelEcoTax.text =[record valueForKey:Cart_Product_name];
    self.labelVAT.text =[record valueForKey:Cart_Product_name];
    self.labelTotal.text =[record valueForKey:Cart_Product_name];
    
    
}

- (void)reloadTotalsView
{
    //@step
    NSArray* list = [[_mappingResult dictionary] valueForKey :Cart_totals];
    [_totalsController relaod:list];
    self.tableView.tableFooterView = _totalsController.view;
}

- (void)onEventCartUpdated
{
    //@step
    int count = [_prodcuts count];
    [self renderToolBar: count >0];
    
    int iquantity = 0;
    //@step
    for (int i=0; i < count; i++) {
        NSDictionary* item = [_prodcuts objectAtIndex:i];
        NSNumber* quantity = [item valueForKey:Product_quantity];
        iquantity = iquantity + [quantity intValue];
    }
    
    NSString* countString = [NSString stringWithFormat:@"%d", iquantity];
    [Resource notifyCartUpdate:countString];
}
- (RKMappingResult*)parseData2Result:(NSData*)data
{
    //@step
     NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary:data];
    RKMappingResult* result = [[RKMappingResult alloc]initWithDictionary:response];
    return  result;
}

- (void)loadData
{
    [[XCartDataManager  sharedInstance ]getCart: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [self parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        _prodcuts = [[_mappingResult dictionary] valueForKey :Cart_products];
        //@step
        [self.tableView reloadData];
        //@step
        [self onEventCartUpdated];
        //@step
        [self reloadTotalsView];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];

}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 151;
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
    NSString* reuseId =@"CartItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
         //
    NSArray* items = _prodcuts;

    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    //cell.textLabel.text = [item valueForKey:Cart_Product_name];
    CartItemCell* theCell = (CartItemCell*)cell;
    theCell.labelName.text =[item valueForKey:Cart_Product_name];
    theCell.labelName.numberOfLines = 2;
    theCell.labelModel.text = [item valueForKey:Cart_Product_model];
    theCell.labelPrice.text =[item valueForKey:Cart_Product_price];
    
    theCell.labelQuantity.text = [Lang safeNumberToIntString:[item valueForKey:Cart_Product_quantity] toValue:@""] ;
    theCell.labelTotal.text = [item valueForKey:Cart_Product_total];
    //@step
    NSString* imageUrlString = [item valueForKey:Product_thumb];
    [Resource assginImageWithSource:theCell.extImageView source:imageUrlString];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* items = _prodcuts;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    AppViewController * viewController = [ProductDetailViewController create];
    viewController.args = item;
    
    [self.navigationController pushViewController:viewController animated:true];
    
}


@end
