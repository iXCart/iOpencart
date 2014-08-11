//
//  PaymentMethodViewController.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "PaymentMethodViewController.h"
#import "CartViewController.h"
#import "XCartDataManager.h"
#import "AddressCell.h"
#import "ConfirmViewController.h"

@interface PaymentMethodViewController ()
{
    NSIndexPath* _selectedIndexPath;
    BOOL _isExpandBottomView;
    
    CGRect _original_frame;

}

@end

@implementation PaymentMethodViewController

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

- (void)expandCommentView
{
    _isExpandBottomView = true;
    
    CGRect frame =  _original_frame;
    CGRect commentFrame = self.commentContainerView.frame;
    CGRect footerFrame = self.agreeTermView.frame;
    frame.size.height = frame.size.height + commentFrame.size.height + footerFrame.size.height + 30;
    
    self.bottomView.frame = frame;
    self.tableView.tableFooterView = self.bottomView;
    
    //self.bottomView.backgroundColor=[UIColor darkGrayColor];
    commentFrame.origin.y = footerFrame.origin.y;
    commentFrame.origin.x = 9;
    self.commentContainerView.frame = commentFrame;
    [self.bottomView addSubview:self.commentContainerView];

    
    footerFrame.origin.y = commentFrame.size.height + commentFrame.origin.y + 10;
    footerFrame.origin.x = 0;
    self.agreeTermView.frame = footerFrame;
    
    [self.agreeTermView removeFromSuperview];
    [self.bottomView addSubview:self.agreeTermView];
    self.agreeTermView.frame = footerFrame;
}

- (void)addAgreeView
{
    CGRect footerFrame = self.agreeTermView.frame;
    footerFrame.origin.y = 80;
    self.agreeTermView.frame = footerFrame;
    
    [self.bottomView addSubview:self.agreeTermView];
}

static NSString* cellId = @"AddressCell";

-(void)prepareTableview
{
    UINib *nib = [UINib nibWithNibName:cellId  bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:cellId];
    
    //@step
    self.tableView.tableFooterView = self.bottomView;
    
    [self addAgreeView];
    _original_frame = self.tableView.tableFooterView.frame;
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Payment Method");
    
    [self prepareTableview];
    
    [Utils roundRectView:self.commentContainerView];
    [Utils roundRectView:self.commentView];
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
    
   //@ [self renderToolBar:true];
}

- (void)showNextScene
{
    
    AppViewController * viewController = [ConfirmViewController create];
    // viewController.args = item;
    
    [self.navigationController pushViewController:viewController animated:true];
    
}


- (IBAction)nextStep:(id)sender
{
    //@step
    NSDictionary* rowData = [self getSelecteRowData];
    if (nil == rowData) {
        return;
    }
    
    NSString* code = [rowData valueForKey:CheckoutShappingMethod_code];
    NSString* comment = self.commentView.text;
    comment = [Lang isEmptyString:comment] ? @"" : comment;

    //@step
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                           
                           code, Checkout_payment_method,
                           comment, Checkout_comment,
                           TRUE_ONE, Checkout_agree,
                           nil];
    //@step
    [[XCartDataManager sharedInstance] savePaymentMethod:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
        [self expandCommentView];
    }
    
}

- (IBAction)onSwitch:(id)sender
{
    
}

- (IBAction)showTerms:(id)sender
{
    
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
    [[XCartDataManager  sharedInstance ]getPaymentMethod: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"mappingResult->[%@]", mappingResult);
        
        _mappingResult =  [self parseData2Result:operation.HTTPRequestOperation.responseData];
        //@step
        NSDictionary* methods = [[_mappingResult dictionary] valueForKey :Checkout_payment_methods];
        if (nil != methods)
        {   if ([methods isKindOfClass:[NSDictionary class]])
            _list =  [methods allValues];
            else
                _list = (NSArray*)methods;
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





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =cellId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    //
    NSArray* items = _list;
    
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    
    AddressCell* theCell = (AddressCell*)cell;
    
    NSString* title = [item valueForKey:CheckoutShippingMethod_title];
    theCell.labelFirst.text =title;
    
    
    //theCell.labelLast.text =[self wrapQuote:item];
    
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
    
    [self.commentView resignFirstResponder];
}

@end
