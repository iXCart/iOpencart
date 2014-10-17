//
//  DataModel.m
//  iApp
//
//  Created by icoco7 on 6/11/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "DataModel.h"
#import "XCartDataManager.h"

@interface DataModel ()
{
    
}
@property (atomic)int taskCount;
@end

@implementation DataModel

+ (DataModel*)sharedInstance{
    
    static dispatch_once_t onceToken;
    static DataModel *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DataModel new];
    });
    return sharedInstance;
}

#pragma mark add proudct to cart
- (void)add2Cart:(NSDictionary*)dict{
   
    //@step
    if ([[XCartDataManager sharedInstance].activeUser isValidateUser]) {
        [self submit2ServerCart:dict];
    }
    else
    {
        if (nil == _localCart) {
            _localCart =[NSMutableArray array];
        }
        
        [_localCart addObject:dict];
        
        NSString* count = [NSString stringWithFormat:@"%d", [_localCart count]];
        [Resource notifyCartUpdate:count];
    }
    
   
    
}

- (NSArray*)getProudctsFromCart{
    return _localCart;
}

- (void)submit2ServerCart:(NSDictionary*)dict
{
    NSString* product_id = [dict valueForKey:Product_product_id];
    NSNumber* quantity = (NSNumber*)[dict valueForKey:Product_quantity];
    if (nil == quantity) {
        quantity = [NSNumber numberWithInt:1];
    }
    
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                        product_id,Product_product_id,quantity,Product_quantity,
                           nil];
    NSString* urlString = [Resource getAddCartURLString];
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodPOST params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            NSDictionary* data = [response valueForKey:Rest_data];
            NSString* total = [data valueForKey:Cart_Product_total];
           
            //@step
           [Resource notifyCartUpdate:total];
            
             NSString* msg = @"Success add product to your shopping cart!";
            [CDialogViewManager showMessageView:@"" message:msg delayAutoHide:2];
            
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];

}

#pragma remove product from cart
- (void)moveProuctFromCart:(NSDictionary*)item
{
    if (nil == _unDeleteProducts) {
        _unDeleteProducts =[NSMutableArray array];
    }
    [_unDeleteProducts addObject:item];
}

- (void)batchRemoveProdcutsFromCart
{
    if (nil == _unDeleteProducts || [_unDeleteProducts count]<=0) {
        return;
    }
    for (NSDictionary* item in _unDeleteProducts) {
        if (item) {
            [self removeProductFromServerCart:item];
            //break;
        }
    }
    
    [_unDeleteProducts removeAllObjects];
}

- (void)resetUnDeleteProducts
{
    if (nil == _unDeleteProducts || [_unDeleteProducts count]<=0) {
        return;
    }
    [_unDeleteProducts removeAllObjects];
}


- (void)removeProductFromServerCart:(NSDictionary*)product
{
    //@ for Opencart v1.5 index.php?route=checkout/cart&remove=29:
    
    //@ for Opencart v2.0 index.php?route=checkout/cart/remove
    //@step
    NSString* productKey = [product valueForKey:CartProdcut_key];
    //@step v1.5
    NSDictionary* params =[NSDictionary dictionaryWithObjectsAndKeys:
                           TRUE_ONE,Rest_json,
                           productKey,@"remove",
                           nil];

    RKRequestMethod method = RKRequestMethodGET;
    NSString* urlString = [Resource getCheckoutCartURLString];
    
    if ([Resource isVersion2]) {
        
        urlString = [NSString stringWithFormat:@"%@/remove", urlString];
        //@step v2.0
        params =[NSDictionary dictionaryWithObjectsAndKeys:
                 TRUE_ONE,Rest_json,
                 productKey,@"key",
                 nil];
        method = RKRequestMethodPOST;
    }
   
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:method params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //@step
        [self finishOneTask];
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
        [self finishOneTask];
        //@step
        
    }];
}

#pragma
- (void)startTaskCount:(int)i
{
    self.taskCount = i;
}

- (void)finishOneTask
{
    @synchronized(self){
        int i = self.taskCount;
        self.taskCount = i -1;
    }
    
    if (0 <= self.taskCount ) {
            [self performSelector:@selector(notifyWhileFinishTask) withObject:nil afterDelay:0.5];
    }
    
}
- (void)notifyWhileFinishTask
{
     [[NSNotificationCenter defaultCenter]postNotificationName:NotifyEventCommpleteUpdateCart object:nil];
}

#pragma mark commitUpdateCart remove and update quanlity
- (void) commitUpdateCart:(NSArray*)list
{
    int iTaskCount = 0;
    
    if (nil != _unDeleteProducts) {
        iTaskCount = [_unDeleteProducts count];
    }
    if (nil != list) {
        iTaskCount = iTaskCount + [list count];
    }
    [self startTaskCount:iTaskCount];
    //@step
    [self batchRemoveProdcutsFromCart];
    [self applyUpdateCart:list];
}

#pragma mark updateCart
- (void)applyUpdateCart:(NSArray*)list
{
    if (nil == list || [list count]<=0) {
        return;
    }
    NSMutableDictionary* updatedProducts = [NSMutableDictionary dictionary];
    for (NSDictionary* item in list) {
        if (item) {
            NSNumber* originalValue = [item valueForKey:Product_quantity_orignal];
            if (nil != originalValue) {
                //@step it was update so then need update db
                NSNumber* value = [item valueForKey:Product_quantity];
                NSString* key = [item valueForKey:CartProdcut_key];
                NSString* name = [NSString stringWithFormat:@"quantity[%@]", key];
                [updatedProducts setValue:value forKey:name];
            }
         }
    }
    //@step
    if ([updatedProducts count]>0) {
        [self persistentUpdateProdcutQuantity:updatedProducts];
    }
    
}

- (void)persistentUpdateProdcutQuantity:(NSDictionary*)products
{
    //@ index.php?route=checkout/cart |post
    //@step
   
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:products];
    [params setValue:TRUE_ONE forKey:Rest_json];
  
    NSString* urlString = [Resource getCheckoutCartURLString];
    if ([Resource isVersion2]) {
         urlString = [NSString stringWithFormat:@"%@/edit", urlString];
    }
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodPOST params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //@step
        [self finishOneTask];
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
        [self finishOneTask];
        //@step
    }];
}

#pragma Account
- (void)login:(NSString*) email password:(NSString*)password{
    
    if ([Lang isEmptyString:email] || [Lang isEmptyString:password]) {
        return;
    }
    //@step
    [[XCartDataManager sharedInstance] login:email pasword:password success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        XCartUser* user = [XCartDataManager sharedInstance].activeUser;
        
        if (nil !=user && [user isValidateUser]) {
            //@step login succcess
            return ;
        }
        //@step
        [self cleanUpUserAccountInfo];
        //@step
        NSString* mssage = @"Failed login";
        
        if ( nil != user &&![user isValidateUser]){
            
            NSDictionary* response = user.response;
            mssage = [response valueForKey:Account_error_warning];
            
        }
        
        [CDialogViewManager showMessageView:@"" message:mssage delayAutoHide: -1];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@->login failure->responseString:[%@]",self, operation.HTTPRequestOperation.responseString);
    }];
}

- (void)auotoLogin
{
    NSDictionary* dict =[Resource loadUserAccountInfo];
    if (nil == dict) return;
    NSString* email = [dict valueForKey:@"email"];
    NSString* password = [dict valueForKey:@"password"];
    
    [self login:email password:password];
    
}

- (void)loutOut
{
    [[XCartDataManager sharedInstance] logout:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            [self cleanUpUserAccountInfo];
             
        }else
        {
            [Resource showRestResponseErrorMessage:response];
        }

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [CDialogViewManager showMessageView:@"" message:[error localizedDescription] delayAutoHide:-1];
    }];
    
}

#pragma mark cache the user account information
- (void)cleanUpUserAccountInfo
{
    NSDictionary* dict =[NSDictionary dictionary];
    [Resource storeUserAccountInfo:dict];
}

- (void)storeUserAccountInfo:(NSString*) email password:(NSString*)password
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password,@"password",nil];
    
    [Resource storeUserAccountInfo:dict];
}
@end
