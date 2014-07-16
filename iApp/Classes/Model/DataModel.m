//
//  DataModel.m
//  iApp
//
//  Created by icoco7 on 6/11/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "DataModel.h"
#import "XCartDataManager.h"

@implementation DataModel

+ (DataModel*)sharedInstance{
    
    static dispatch_once_t onceToken;
    static DataModel *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DataModel new];
    });
    return sharedInstance;
}

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
