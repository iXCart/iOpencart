//
//  ConfirmViewController.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ConfirmViewController.h"
#import "DataModel.h"
#import "ProductDetailViewController.h"
#import "XCartDataManager.h"
#import "CartItemCell.h"
#import "PaymentAddressViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

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
    
    self.tableView.tableFooterView = self.bottomView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Confirm Order");
    
    [self prepareTableview];
   
    
}
- (void)renderToolBar:(BOOL)visiable
{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
}

- (void)showNextScene
{
    [self.navigationController popToRootViewControllerAnimated:true];;
    return;
    NSString* message = @"Your Order Has Been Processed!\nThanks for shopping with us online!";
    [CDialogViewManager showMessageView:@"" message:message delayAutoHide:-1];

    
    return;
    AppViewController * viewController = [PaymentAddressViewController create];
    // viewController.args = item;

    [self.navigationController pushViewController:viewController animated:true];
}

- (void)doSuccessAction
{
    //@ //127.0.0.1/o2/index.php?route=checkout/success
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                           nil];
    NSString* urlString = [Resource getCheckoutSuccessURLString];
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            
            NSDictionary* data = [response valueForKey:Rest_data];
            NSString* message = [data valueForKey:@"heading_title"];
            [CDialogViewManager showMessageView:@"" message:message delayAutoHide:-1];
            //@step
            [self showNextScene];
            
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
    
}
- (IBAction)nextStep:(id)sender
{   //@ index.php?route=payment/cod/confirm
    //@step
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                           nil];
    NSString* urlString = [Resource getPaymentConfirmURLString];
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodGET params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            [self doSuccessAction];
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
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
- (RKMappingResult*)parseData2Result:(NSData*)data
{
    //@step
     NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary:data];
    RKMappingResult* result = [[RKMappingResult alloc]initWithDictionary:response];
    return  result;
}

- (void)loadData
{
    [[XCartDataManager  sharedInstance ]getCheckoutConfirmMethod: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [self parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        _prodcuts = [[_mappingResult dictionary] valueForKey :Cart_products];
        //@step
        [self.tableView reloadData];
      
        
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
