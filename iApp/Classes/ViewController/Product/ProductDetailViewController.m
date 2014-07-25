//
//  ProductDetailViewController.m
//  iApp
//
//  Created by icoco7 on 6/16/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "XCartKit.h"
#import "WebViewCell.h"
#import "ImageViewCell.h"

#import "CTableViewCell.h"
#import "DataModel.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)renderToolbar
{
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(add2Cart:)];
    [self.navigationItem setRightBarButtonItem:button];
}

-( NSArray*) loadDefs
{
    NSString* cfgFilePath =[Utils getBundleFileAsFullPath:  @"proudctDefs.plist"];
    NSArray* data = [NSArray arrayWithContentsOfFile:cfgFilePath];
	if (nil == data || [data count]<=0) {
		NSLog(@"Miss read data from->[%@]", cfgFilePath);
		return nil;
	}
    NSLog(@"%@->loadDefs:[%@]",self, data);
    return data;
}

- (void)registerTableViewCells2TableView:(NSString*)className
{
    UINib* nib = [UINib nibWithNibName: className bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:className];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self renderToolbar];
    // Do any additional setup after loading the view from its nib.
    [self registerTableViewCells2TableView:@"BaseCell"];
    [self registerTableViewCells2TableView:@"WebViewCell"];
    [self registerTableViewCells2TableView:@"ImageViewCell"];
    [self registerTableViewCells2TableView:@"ImagePagesViewCell"];
    NSString* name  =[self.args valueForKey:@"name"];
    self.title = name;
    //@step
    _defs = [self loadDefs];
    //@step
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark add2Cart
- (IBAction)add2Cart:(id)sender{
    
    [[DataModel sharedInstance] add2Cart:_resultDictionary];
  
}

#pragma makr loadData
- (void)loadData
{
    if (nil == self.args) {
        return;
    }
    NSString* productId = [self.args valueForKey:@"product_id"];
    //@step
    [[XCartDataManager  sharedInstance ]getProductDetailsById:productId success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"[%@]->mappingResult->[%@]", self,mappingResult);
          NSLog(@"[%@]->mappingResult->Dictionary[%@]", self,mappingResult.dictionary);
        _mappingResult = mappingResult;
        
        if (nil != _mappingResult) {
            NSData* data = operation.HTTPRequestOperation.responseData;
            _resultDictionary = [Lang paseJSONDatatoArrayOrNSDictionary:data];
            
            NSLog(@"->loadData->_resultDictionary:[%@]",_resultDictionary);
            
        }
        //@step
        [self.tableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
    
}



#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isRefRow:indexPath]) {
        return 44;
    }
    NSDictionary* item = [self getRowDef:indexPath];
    NSString* value = [item valueForKey:@"height"];
    if (![Lang isEmptyString:value]) {
        CGFloat height = [value floatValue];
        return  height;
    }
    
    return 44;
//    
//    NSDictionary* item = [self getRowDef:indexPath];
//    NSString* type = [item valueForKey:@"type"];
//    
//    if (StringEqual(@"HTML", type)) {
//        return 200.0;
//    }
//    if (StringEqual(@"Image", type)) {
//        return 300.0;
//    }
 
    return 44;

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
    NSString* value = [def valueForKey:@"value"];
    if (![Lang isEmptyString:value]) {
        //@step the value should like : @discount , it point to which field should be load, the filed shold be array
        NSString* mapFieldName = [value stringByReplacingOccurrencesOfString:@"@" withString:@""];
        NSArray* items = [_resultDictionary valueForKey:mapFieldName];
        if (nil!= items) {
            return [items count];
        }
    }
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

- (NSString*)retrieveTextTitleFromResult:(NSString*)name{
    
    NSString* keyOfTextTitle = [NSString stringWithFormat:@"text_%@", name];
    //@step
    NSString* defTitle = [_resultDictionary valueForKey: keyOfTextTitle];
    //@step
    return  [Lang isEmptyString:defTitle] ? name :defTitle;
}


- (UITableViewCell*)getCellWithMatchedType:(UITableView *)tableView  indexPath:(NSIndexPath*)indexPath{
    NSString* reuseId = @"BaseCell";
    //@step
    NSDictionary* item = [self getRowDef:indexPath];
    NSString* type = [item valueForKey:@"type"];
    
    if (StringEqual(@"HTML", type)) {
         reuseId = @"WebViewCell";
    }
    if (StringEqual(@"Image", type)) {
        reuseId = @"ImagePagesViewCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    return cell;
}

- (BOOL)isRefRow:(NSIndexPath*) indexPath{
    NSDictionary* def = (NSDictionary*)[_defs objectAtIndex:indexPath.section];
    //@step
    NSString* value = [def valueForKey:@"value"];
    return ![Lang isEmptyString:value];
    
}

- (UITableViewCell *)cellForRefRow:(NSIndexPath *)indexPath
{
    //@@ for discounts
    NSDictionary* def = (NSDictionary*)[_defs objectAtIndex:indexPath.section];
    //@step
    NSString* value = [def valueForKey:@"value"];
    if ([Lang isEmptyString:value]) return nil;

    //@step the value should like : @discounts , it point to which field should be load, the filed value 'discounts' shold be array
    NSString* mapFieldName = [value stringByReplacingOccurrencesOfString:@"@" withString:@""];
    NSArray* itemsOfResult = [_resultDictionary valueForKey:mapFieldName];
    if (nil == itemsOfResult) {
        return nil; //should not occurs
    }
    NSLog(@"cellForRefRow->_resultDictionary:%@,itemsOfResult:%@",_resultDictionary, itemsOfResult);
     NSString* fomrat = [_resultDictionary valueForKey:Product_text_discount];
    
    NSDictionary* item = [itemsOfResult objectAtIndex:indexPath.row];
    
    NSString* price = [item valueForKey: Product_Discounts_price];
    
    NSString* quantity = [item valueForKey:Product_Discounts_quantity];
   
    //@step the value like : '%s or more %s'
    //  need convert the format to objective c format : '%@ or more %@'
    
    fomrat = [fomrat stringByReplacingOccurrencesOfString:@"%s" withString:@"%@" ];
    NSString* text = [NSString stringWithFormat:fomrat,quantity, price];
    //@step
    NSString* reuseId = @"BaseCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    cell.textLabel.text = text;
    
    
    return cell;
}

#pragma mark tableView cellForRowAtIndexPath
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if ([self isRefRow:indexPath]) {
         return [self cellForRefRow:indexPath];
     }
     if (0) {
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseCell" forIndexPath:indexPath];
         return cell;
     }
     //@step
     UITableViewCell *cell = [self getCellWithMatchedType:tableView indexPath:indexPath];
  
     NSDictionary* item = [self getRowDef:indexPath];
     NSString* name = [item valueForKey:@"name"];
     
     NSString* title = [item valueForKey:@"title"];
     if ([Lang isEmptyString:title]) {
         title =[self retrieveTextTitleFromResult:name];
     }
     NSString* value = [_resultDictionary valueForKey:name];
     if (![value isKindOfClass:[NSString class ]]) {
         value = [value description];
     }
     
     //@step
     do{
         //@step
         if ([cell isKindOfClass:[WebViewCell class]]) {
             WebViewCell* webCell = (WebViewCell*)cell;
             [webCell.webView loadHTMLString:value baseURL:nil];
             break;
         }
         //@step
         if ([cell isKindOfClass:[ImageViewCell class]]) {
             ImageViewCell* imageCell = (ImageViewCell*)cell;
 
             //@step
             [Resource assginImageWithSource:imageCell.imageLayerView source:value];
             
             break;
         }
         //@step
         if ([cell isKindOfClass:[CTableViewCell class] ])
         {
              CTableViewCell* theCell = (CTableViewCell*) cell;
             
             [theCell setArgs:_resultDictionary];
             
             return cell;
              break;
         }

         //@step
         cell.textLabel.text = title;
         cell.detailTextLabel.text = value;
     }while (false);
     
 
 return cell;
 }




@end
