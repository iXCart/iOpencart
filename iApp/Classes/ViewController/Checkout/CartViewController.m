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
    } }

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Shopping Cart");
    
    [self prepareTableview];
   
    [self registerListener];
    
}

- (void)viewDidUnload
{
    [self unRegisterListener];
}

- (void)renderLeftButton:(BOOL)inEditMode
{
    UIBarButtonItem* button = nil;
    if (inEditMode) {
             button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    }else
        button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];

   
    [self.navigationItem setLeftBarButtonItem:button animated:true];
}
- (void)renderToolBar:(BOOL)visiable
{
    if (visiable) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStylePlain target:self action:@selector(checkOut:)];
        [self.navigationItem setRightBarButtonItem:button];
        
        //[self renderLeftButton:self.editing];
        return;
         button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
        [self.navigationItem setLeftBarButtonItem:button];
        
    }else
    {
        [self.navigationItem setRightBarButtonItem:nil];
        [self.navigationItem setLeftBarButtonItem:nil];
    }
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    
    self.editing = false;
    [[DataModel sharedInstance]resetUnDeleteProducts];
    
    
}


- (void)saveAction:(id)sender
{
    //@step remove
    [[DataModel sharedInstance]commitUpdateCart:_prodcuts];
    //@step update
    
    //@step
    self.editing = false;
}

- (void)editAction:(id)sender
{
    self.editing = true;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    //self.tableView.editing = editing;
    
    [self renderLeftButton:editing];
    
    
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
    if (nil == _prodcuts || [_prodcuts count] ==0) {
        self.tableView.tableFooterView  = nil;
    }else
    {
        self.tableView.tableFooterView = _totalsController.view;
    }
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



- (NSArray*)formatProdcuts:(NSArray*)products
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity: [products count]];
    for (NSDictionary* item in products) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary: item];
        [result addObject:dict];
    }
    return  result;
}


#pragma mark data routine 

#pragma loadData
- (void)loadData
{
    [[XCartDataManager  sharedInstance ]getCart: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [Resource parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        _prodcuts =[self formatProdcuts: [[_mappingResult dictionary] valueForKey :Cart_products]];
        
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
    NSString* reuseId =@"CartItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId ];
    //[[CartItemCell alloc]initWithFrame:CGRectZero];
    //
    NSArray* items = _prodcuts;

    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    //cell.textLabel.text = [item valueForKey:Cart_Product_name];
    CartItemCell* theCell = (CartItemCell*)cell;
    
    [theCell setArgs:item];
    theCell.observer = self ;
    theCell.indexPath = indexPath;
    return cell;
}

- (void)removeRow:(UITableViewCell*)sender
{
    CartItemCell* cell = (CartItemCell*)sender;
    NSIndexPath* indexPath = cell.indexPath;
    NSMutableArray* items = (NSMutableArray*) _prodcuts;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    [self removeProduct:item];
    
    [items removeObjectAtIndex:row];
    
    // Delete the row from the data source
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)update:(id)sender  value :(id) value
{
    NSLog(@"%@->update:%@,%@",self,sender,value);
    do{
        if (nil == sender || ![sender isKindOfClass:[CartItemCell class]]) {
            break;
        }
        if (nil != value && StringEqual(@"delete",value)){
            [self removeRow:sender];
            
        }else
        { //@ increment or discerment
            if (!self.editing) {
                [self setEditing:true animated:true];
            }
         }
        
    }while(false);
    
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


- (void)onNotifyEventCommpleteUpdateCart:(NSNotification*)notifycation
{
    //@step refresh the view
    [self loadData];
}

-(void) registerListener {
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyEventCommpleteUpdateCart: )
 												 name: NotifyEventCommpleteUpdateCart object:nil];
    
    
}
-(void) unRegisterListener{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyEventCommpleteUpdateCart object:nil];
    
}


@end
