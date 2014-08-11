//
//  ShippingMethodViewController.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ShippingMethodViewController.h"
#import "PaymentMethodViewController.h"
#import "XCartDataManager.h"
#import "AddressCell.h"
@interface ShippingMethodViewController ()
{
    NSIndexPath* _selectedIndexPath;
    BOOL _isExpandBottomView;
    
    CGRect _original_frame;
    
}

@end

@implementation ShippingMethodViewController

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

- (void)swithcBottomView:(BOOL)expand
{
    if (!expand) {
        CGRect frame = _original_frame;
        frame.size.height = 80;
        self.bottomView.frame = frame;
        
    }
    else
    {
        CGRect frame = _original_frame;
        frame.size.height = 220;
        self.bottomView.frame = frame;
    }
    
    _isExpandBottomView = expand;
    self.commentContainerView.hidden = !expand;
    
   
    self.tableView.tableFooterView =self.bottomView;
 
    
}

static NSString* cellId = @"AddressCell";

-(void)prepareTableview
{
    UINib *nib = [UINib nibWithNibName:cellId  bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:cellId];
    
    //@step
    self.tableView.tableFooterView = self.bottomView;
    
    _original_frame = self.bottomView.frame;
    
    [self swithcBottomView:false];
   
    [Utils roundRectView:self.commentContainerView];
    [Utils roundRectView:self.commentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Delivery Method");
    
    [self prepareTableview];
    
    
}
- (void)renderToolBar:(BOOL)visiable
{
    if (visiable) {
        UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
        [self.navigationItem setRightBarButtonItem:button];
    }else
        [self.navigationItem setRightBarButtonItem:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    
    [self loadData];
    
    [self renderToolBar:true];
}

- (void)showNextScene
{
    
    AppViewController * viewController = [PaymentMethodViewController create];
    // viewController.args = item;
    
    [self.navigationController pushViewController:viewController animated:true];
    
}


- (void)nextStep:(id)sender
{
    [self.commentView resignFirstResponder];
    //@step
    //@step
    NSDictionary* rowData = [self getSelecteRowData];
    if (nil == rowData) {
        return;
    }
    NSDictionary* dict = [rowData valueForKey:CheckoutShippingMethod_quote];
    NSDictionary* subItem = [dict valueForKey:CheckoutShappingMethod_flat];
    
    NSString* code = [subItem valueForKey:CheckoutShappingMethod_code];
    NSString* comment = self.commentView.text;
    comment = [Lang isEmptyString:comment] ? @"" : comment;
    //@step
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                           
                           code, Checkout_shipping_method,
                           comment, Checkout_comment,
                           nil];
    //@step
    [[XCartDataManager sharedInstance] saveShippingMethod:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            [self showNextScene];
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
    
}


- (IBAction)addComment:(id)sender
{
    if (!_isExpandBottomView) {
        [self swithcBottomView:true];
    }
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
    [[XCartDataManager  sharedInstance ]getShippingMethod: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [self parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        NSDictionary* shipping_methods = [[_mappingResult dictionary] valueForKey :Checkout_shipping_methods];
        if (nil != shipping_methods)
        {   if ([shipping_methods isKindOfClass:[NSDictionary class]])
            _list =  [shipping_methods allValues];
            else
                _list = (NSArray*)shipping_methods;
        }else
            _list = [NSArray array];
        //@step
        [self.tableView reloadData];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
}

#pragma mark getSelecteRowData
- (NSDictionary*)getSelecteRowData
{
    if (nil == _list) {
        return nil;
    }
    NSArray* items = _list;
    int row = _selectedIndexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    return item;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_list count];;
}



-( NSString*)wrapQuote:(NSDictionary*)item
{
    //@step
    NSDictionary* dict = [item valueForKey:CheckoutShippingMethod_quote];
    NSDictionary* subItem = [dict valueForKey:@"flat"];
    NSString* title = [subItem valueForKey:CheckoutShippingMethod_title];
    NSString* text = [subItem valueForKey:CheckoutShippingMethod_text];
    
    
    NSString* result = [NSString stringWithFormat:@"%@,%@",
                        title,text];
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =cellId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    //
    NSArray* items = _list;
    
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    //cell.textLabel.text = [item valueForKey:Cart_Product_name];
    AddressCell* theCell = (AddressCell*)cell;
    
    NSString* title = [item valueForKey:CheckoutShippingMethod_title];
    theCell.labelFirst.text =title;
    
    
    theCell.labelLast.text =[self wrapQuote:item];
    
    if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        theCell.leftImageView.image = [UIImage imageNamed:@"row_selected.png"];
    }else
        theCell.leftImageView.image = nil;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* items = _list;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    if ( [indexPath compare:_selectedIndexPath] == NSOrderedSame) {
        _selectedIndexPath = nil;
    }else{
        _selectedIndexPath = indexPath;
    }
    
    //@step
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:0];
    [self.tableView  reloadSections:set  withRowAnimation:UITableViewRowAnimationFade];
    
    
    //@step
    [self.commentView resignFirstResponder];
}


#pragma textView
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    [textView resignFirstResponder];
}

@end
