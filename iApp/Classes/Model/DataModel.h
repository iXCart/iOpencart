//
//  DataModel.h
//  iApp
//
//  Created by icoco7 on 6/11/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
{
    NSMutableArray*  _localCart;
    
    NSMutableArray* _unDeleteProducts;
    
     
}

+ (DataModel*)sharedInstance;


- (void)add2Cart:(NSDictionary*)dict;
- (NSArray*)getProudctsFromCart;

- (void)moveProuctFromCart:(NSDictionary*)item;
//- (void)batchRemoveProdcutsFromCart;
- (void)resetUnDeleteProducts;

- (void)commitUpdateCart:(NSArray*)list;



- (void)auotoLogin;

- (void)loutOut;

//- (void)cleanUpUserAccountInfo;

- (void)storeUserAccountInfo:(NSString*) email password:(NSString*)password;
@end
