//
//  Resource.h
//  iCart
//
//  Created by icoco7 on 5/21/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
 
#else
#define NSLog(...)

#endif

extern  NSString* NotifyEventCommpleteAddCart ;

@interface Resource : NSObject


+(UIColor*) getStandardColor;
 
+ (NSString*)getBaseURLString;

+ (NSString*)getIndexURLString;

+ (NSString*)getCategoriesURLString;

+ (NSString*)getProductsURLString; 

+ (NSString*)getLoginURLString;

+ (NSString*)getCartURLString;

+ (NSString*)getAddCartURLString;

+ (NSString*)getPaymentConfirmURLString;

+ (NSString*)getCheckoutSuccessURLString;

+ (NSString*)getLogoutURLString;

+ (NSArray*)getImagesDefsFromProductResult:(NSDictionary*)dict;

+ (void) assginImageWithSource:(UIImageView*)target  source:(NSString*)source;

+ (void)storeUserAccountInfo:(NSDictionary*) dict;

+ (NSDictionary*)loadUserAccountInfo;

+ (void)showRestResponseErrorMessage:(NSDictionary*)response;

+ (void)notifyCartUpdate:(NSString*)count;
@end
