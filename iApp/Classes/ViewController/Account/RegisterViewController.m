//
//  RegisterViewController.m
//  iApp
//
//  Created by icoco7 on 11/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "XCartKit.h"
#import "DataModel.h"
#import "EditTextFieldCell.h"
#import "RadioCell.h"
#import "ButtonCell.h"
#import "CWebViewController.h"

@interface RegisterViewController()
{
    NSArray* _defs;
    NSMutableDictionary* _form;
    EditTextFieldCell* _activeCell;
}
@end

static NSString* _reuseID = @"EditTextFieldCell";
static NSString* _radioCell = @"RadioCell";
static NSString* _buttonCell = @"ButtonCell";
static NSString* _radioLinkCell = @"RadioLinkCell";


@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)saveAction:(id)sender
{
    NSDictionary* params = [self getInputParams];
    if (nil == params || [params count]<=0) {
        return;
    }
    if (nil != _activeCell) {
        [_activeCell.textField resignFirstResponder];
    }
    //@step
    
    //@step
    NSString* urlString = [Resource getAccountRegisterURLString] ;
    
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
            NSString* message = AppLocalizedString(@"Register success!");
            [CDialogViewManager showMessageView: @"" message:message delayAutoHide:-1];
            [self.navigationController popViewControllerAnimated:true];
        }else
        {
            NSString* message = AppLocalizedString(@"Register failed!");
            [CDialogViewManager showMessageView: @"" message:message delayAutoHide:-1];
            
            //[Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString* buf = operation.HTTPRequestOperation.responseString;
        buf = [Lang trimString:buf];
        
        [CDialogViewManager showMessageView: [Lang trimString:[error localizedDescription]] message:buf delayAutoHide: 3];
        //@step
        
        //@step
    }];
}

- (NSMutableDictionary*)getInputParams
{
    return _form;
    
}

-(void)prepareTableview
{
    UINib *nib = [UINib nibWithNibName:_reuseID bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:_reuseID];
    
  
    nib = [UINib nibWithNibName:_radioCell bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:_radioCell];
    
    nib = [UINib nibWithNibName:_buttonCell bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:_buttonCell];
    
    nib = [UINib nibWithNibName:_radioLinkCell bundle:nil];
    [self.tableView registerNib:nib
         forCellReuseIdentifier:_radioLinkCell];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Register");
    [self prepareTableview];
    
    return;
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    [self.navigationItem setRightBarButtonItem:button];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //@step
    [self loadData];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDefsDataToView
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

-(NSArray*) loadDefs
{
    NSString* cfgFilePath =[Utils getBundleFileAsFullPath:  @"registerDefs.plist"];
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
     [self loadDefsDataToView];
}

#pragma mark - form data source
- (NSString*)getInputValueByKey:(NSString*)key
{
    if (nil == _form) {
        return nil;
    }
    
    return [_form valueForKey:key];
}

- (void)setInputValue:(NSString*)key value:(NSString*)value
{
    if (nil == _form) {
        _form = [NSMutableDictionary dictionary];
    }
    [_form setValue:value forKey:key];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return  [_defs count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* def = (NSDictionary*)[_defs objectAtIndex:section];
    //@step

    NSArray* items = [def valueForKey:@"fields"];
    
    return [items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary* def = (NSDictionary*)[_defs objectAtIndex:section];
    NSString* title = [def valueForKey:@"name"];
    return title;
}

- (NSDictionary*) getRowDef:(NSIndexPath*)indexPath
{
    NSDictionary* def = (NSDictionary*)[_defs objectAtIndex:indexPath.section];
    
    NSArray* items = [def valueForKey:@"fields"];
    
    NSDictionary* item = [items objectAtIndex:indexPath.row];
    return item;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary* item = [self getRowDef:indexPath];
 
    NSNumber* height = [item valueForKey:@"height"];
    if (nil != height) {
        return  [height floatValue];
    }
    return 60;
}


- (UITableViewCell*)cell4ButtonCelltableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId = _buttonCell;
    ButtonCell *cell = (ButtonCell*) [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    NSDictionary* item = [self getRowDef:indexPath];
    
    [cell setArgs:item];
    
    NSString* title = [item valueForKey:@"title"];
    [cell.button setTitle:title forState:UIControlStateNormal];
     
    [cell.contentView sendSubviewToBack:cell.textLabel];
    
    cell.observer = self;
    return cell;
}

- (void)setDefaultRadioValue:(NSDictionary*)item  cell:(RadioCell*)cell
{
    NSString* key = [item valueForKey:@"name"];
   
    if (nil == [self getInputValueByKey:key]) {
        //@step
         NSString* value =  [item valueForKey:@"value"];
        [self setInputValue:key value:value];
        //@step
       
        BOOL selected = [Lang toBool:value];
        cell.switchButton.on = selected;
    }
    
}

- (UITableViewCell*)cell4RadioLinkCelltableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId = _radioLinkCell;
    RadioCell *cell = (RadioCell*) [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    NSDictionary* item = [self getRowDef:indexPath];
    
    [cell setArgs:item];
    cell.observer = nil;
    
    [self setDefaultRadioValue:item cell:cell];
    
    NSString* title = [item valueForKey:@"title"];
    if (![Lang isEmptyString:title]) {
        //cell.textLabel.text = title;
       // [cell.contentView sendSubviewToBack:cell.textLabel];
        
    }
    
    
    
    cell.observer = self;
    
    return cell;
}

- (UITableViewCell*)cell4RadioCelltableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId = _radioCell;
     RadioCell *cell = (RadioCell*) [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    NSDictionary* item = [self getRowDef:indexPath];
    
    [cell setArgs:item];
    cell.observer = nil;
    
    [self setDefaultRadioValue:item cell:cell];
    
    NSString* title = [item valueForKey:@"title"];
    if (![Lang isEmptyString:title]) {
        cell.textLabel.text = title;
        [cell.contentView sendSubviewToBack:cell.textLabel];
         cell.textLabel.textColor = [UIColor grayColor];

    }
   
   
    
    cell.observer = self;
   
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseId = _reuseID;
    
    NSDictionary* item = [self getRowDef:indexPath];
    NSLog(@"cellForRowAtIndexPath->%@",item);
    //@step
    NSString* type = [item valueForKey:@"type"];
    if (![Lang isEmptyString:type] && StringEqual(_radioCell, type)) {
        return [self cell4RadioCelltableView:tableView indexPath:indexPath];
    }
    if (![Lang isEmptyString:type] && StringEqual(_buttonCell, type)) {
        return [self cell4ButtonCelltableView:tableView indexPath:indexPath];
    }
    if (![Lang isEmptyString:type] && StringEqual(_radioLinkCell, type)) {
        return [self cell4RadioLinkCelltableView:tableView indexPath:indexPath];
    }
    EditTextFieldCell *cell = (EditTextFieldCell*) [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    
    
    [cell setArgs:item];
    
    NSString* title = [item valueForKey:@"title"];
    if (StringEqual(title,@"BLANK")) {
        title = @"";
        
    }
    
    //@step
    cell.textField.enabled =  ![Lang toBool:[item valueForKey:@"readonly"]];
    //@step
    cell.textField.placeholder = title;
    cell.textField.floatingLabelTextColor = [UIColor darkGrayColor];
    //@step
    NSString* key = [item valueForKey:@"name"];
    NSString* value = [self getInputValueByKey:key];
    cell.textField.text = [Lang safeString:value toValue:@""];
    //@step
    BOOL isSecureTextEntry = [Lang toBool:[item valueForKey:@"secure"]];
    cell.textField.secureTextEntry = isSecureTextEntry;
    
    [cell layoutIfNeeded];
    
    cell.observer = self;
    
    return cell;
}



- (void)processCommand:(NSDictionary*)dict
{
    NSString* class = (NSString*) [dict valueForKey:@"class"];
    do{
        if ([Lang isEmptyString:class]) {
            break;
        }

        UIViewController* viewController = [CUIEnginer createViewController:class inNavigationController:false];
        [self.navigationController pushViewController:viewController animated:true];
        
        
    }while (false);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
    
    NSDictionary* item = [self getRowDef:indexPath];
    [self processCommand:item];
    
    
}




- (void)updateWithButtonCell:(id)sender value:(id)value
{
    if (nil == sender || ![sender isKindOfClass:[ButtonCell class]])
    {
        return;
    }
    
    [self saveAction:nil];
}

- (void)showPolicyView
{
   CNavigationController* nav = (CNavigationController*) [CUIEnginer createViewController:@"CWebViewController" inNavigationController:true];
    CWebViewController* viewController = (CWebViewController*)nav.topViewController;

    //@step
    NSString* urlString = [Resource getPrivacyPolicyURLString];
    
    
    viewController.title = AppLocalizedString(@"Privacy Policy");
    //@step
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nav.topViewController action:@selector(closeView:)];
    [viewController.navigationItem setRightBarButtonItem:button];
    //@step
    [self presentViewController:nav animated:true completion:^{
                      [viewController loadURLByString:urlString];
  
    }];
    
}

- (void)updateWithRadioCell:(id)sender value:(id)value
{
    if (nil == sender || ![sender isKindOfClass:[RadioCell class]])
    {
        return;
    }
    //@step
    if (nil != value && [value isKindOfClass:[UIButton class]]) {
        [self showPolicyView];
        return;
    }
    //@step
    RadioCell* cell = (RadioCell*)sender;
    NSDictionary* item = (NSDictionary*)cell.getArgs;
    NSString* key = [item valueForKey:@"name"];
    
    UISwitch* choice = (UISwitch*)value;
    NSString* inputValue = [Lang toBoolString:choice.selected];
    
    [self setInputValue:key value:inputValue];
}

- (void)update:(id)sender value:(id)value
{
    NSLog(@"%@->update,%@,%@", self,sender, value);
    if (nil != sender && [sender isKindOfClass:[EditTextFieldCell class]])
    {
        _activeCell = (EditTextFieldCell*)sender;
    }
    //@step
    if (nil != sender && [sender isKindOfClass:[RadioCell class]])
    {
        return [self updateWithRadioCell:sender value:value];
    }
    //@step
    if (nil != sender && [sender isKindOfClass:[ButtonCell class]])
    {
        return [self updateWithButtonCell:sender value:value];
    }
    //@step
    if (nil != value && [value isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary* item = (NSDictionary*)value;
        NSString* key = [item valueForKey:@"name"];
        NSString* value = [item valueForKey:@"value"];
        [self setInputValue:key value:value];
        
        _activeCell = nil;
    }

    
}

- (void)updateCountryStateFields;
{
    if (self.args) {
        //@step
      
        NSString* key = @"country_id" ;
        NSString* value = [self.args valueForKey:key];
        [self setInputValue:key value:value];
        //@step
        key = @"name" ;
        value = [self.args valueForKey:key];
        key = @"country";
        [self setInputValue:key value:value];
        


        //@step
        if (1) {
            NSDictionary* zone = [self.args valueForKey:@"zone"];
            NSString* key = @"zone_id" ;
            NSString* value = [zone valueForKey:key];
            [self setInputValue:key value:value];
            //@step
            key = @"name" ;
            value = [zone valueForKey:key];
            key = @"zone";
            [self setInputValue:key value:value];

        }
        
        //@step
        NSArray* cells = [self.tableView visibleCells];
        [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
