//
//  AddressViewController.m
//  iApp
//
//  Created by icoco7 on 7/26/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "AddressViewController.h"
#import "EditTextFieldCell.h"
#import "XCartDataManager.h"

@interface AddressViewController ()
{
    NSArray* _defs;
    
    UITextField* _activeField;
}
@end

@implementation AddressViewController


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
    UINib *nib = [UINib nibWithNibName:@"EditTextFieldCell" bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"EditTextFieldCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"New Address");
    [self prepareTableview];
    
   UIBarButtonItem*  button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
    [self.navigationItem setLeftBarButtonItem:button];
    
    button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    [self.navigationItem setRightBarButtonItem:button];
}


- (NSMutableDictionary*)getInputParams
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSDictionary* item in _defs) {
        NSString* name = [item valueForKey:@"name"];
        NSString* value = [item valueForKey:@"value"];
        value = [Lang safeString:value toValue:@""];
        [params setObject:value forKey:name];
    }

    return  params;
}

- (void)saveAction:(id)sender
{
    NSDictionary* params = [self getInputParams];
    if (nil == params || [params count]<=0) {
        return;
    }
    if (self.isShippingAddress) {
        [params setValue:@"new" forKey:@"shipping_address"];
    }
    //@ index.php?route=checkout/cart |post
    //@step
    
   // NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:products];
   // [params setValue:TRUE_ONE forKey:Rest_json];
    
    NSString* urlString =self.isShippingAddress ? [Resource getAddShippingAddressURLString] :[Resource getAddPaymentAddressURLString];
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodPOST params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //@step
        
        //@step
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString* buf = operation.HTTPRequestOperation.responseString;
        [CDialogViewManager showMessageView:[error localizedDescription] message:buf delayAutoHide: 3];
        //@step
        
        //@step
    }];
}

- (void)cancelAction:(id)sender
{
    [self.parentViewController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    NSString* cfgFilePath =[Utils getBundleFileAsFullPath:  @"addressViewDef.plist"];
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
    NSArray* array = [self loadDefs ];
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary* item in array) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:item];
        [list addObject:dict];
    }
    
    _defs = list;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray* items = _defs;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];
    NSNumber* height = [item valueForKey:@"height"];
    if (nil != height) {
        return  [height floatValue];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId =@"EditTextFieldCell";
    
    EditTextFieldCell *cell = (EditTextFieldCell*) [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.indexPath = indexPath;

    NSArray* items = _defs;
    int row = indexPath.row;
    NSDictionary* item = [items objectAtIndex:row];

    [cell setArgs:item];
    
    NSString* title = [item valueForKey:@"title"];
    if (StringEqual(title,@"BLANK")) {
        title = @"";
        cell.textField.enabled = false;
    }
    else
    {
        cell.textField.enabled = true;
    }
    
    cell.textField.placeholder = title;
    cell.textField.floatingLabelTextColor = [UIColor blackColor];
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)processCommand:(NSDictionary*)dict
{
    NSString* class = (NSString*) [dict valueForKey:@"class"];
    if (StringEqual(class, @"Logout")) {
        
      
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

#pragma mark keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    UIScrollView* containerView = self.tableView;
    CGRect  activeFrame ;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.view.frame;
    frame.size.height -= kbSize.height;
    CGPoint fOrigin = activeFrame.origin;
    fOrigin.y -= containerView.contentOffset.y;
    fOrigin.y += activeFrame.size.height;
    if (!CGRectContainsPoint(frame, fOrigin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeFrame.origin.y + activeFrame.size.height - frame.size.height);
        [containerView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)update:(id)sender value:(id)value
{
    
}
@end
