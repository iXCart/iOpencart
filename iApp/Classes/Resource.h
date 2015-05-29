//
//  Resource.h
//  iCart
//
//  Created by icoco7 on 5/21/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

//#undef DEBUG

#ifdef DEBUG
    
#else

    #define NSLog(...)

#endif



extern  NSString* NotifyEventCommpleteAddCart ;

extern  NSString* NotifyEventCommpleteUpdateCart;

extern const NSString* KeyOfStoreURL ;
extern const NSString* DefaultValueOfStoreURL ;


@interface Resource : NSObject

+ (void)setupLogger;

+(UIColor*) getStandardColor;
 
+ (NSString*)getBaseURLString;

+ (BOOL)isVersion2;

+ (NSString*)getIndexURLString;

+ (NSString*)getCategoriesURLString;

+ (NSString*)getProductsURLString; 

+ (NSString*)getSearchProductsURLString;

+ (NSString*)getCartURLString;

+ (NSString*)getAddCartURLString;

+ (NSString*)getCheckoutCartURLString;

+ (NSString*)getSavePaymentAddressURLString;

+ (NSString*)getAddPaymentAddressURLString;

+ (NSString*)getSaveShippingAddressURLString;

+ (NSString*)getAddShippingAddressURLString;

+ (NSString*)getSaveShippingMethodURLString;

+ (NSString*)getSavePaymentMethodURLString;

+ (NSString*)getPaymentConfirmURLString;

+ (NSString*)getCheckoutSuccessURLString;

+ (NSString*)getLoginURLString;

+ (NSString*)getLogoutURLString;

+ (NSString*)getAccountEditURLString;

+ (NSString*)getAccountRegisterURLString;

+ (NSString*)getCountriesURLString;

+ (NSString*)getRegionOrStateURLString;

+ (NSString*)getAccountWishlistURLString;

+ (NSString*)getOrderHistoryURLString;

+ (NSString*)getAboutURLString;

+ (NSString*)getPrivacyPolicyURLString;

+ (NSString*)getResetPasswordURLString;

+ (RKMappingResult*)parseData2Result:(NSData*)data;

+ (NSArray*)getImagesDefsFromProductResult:(NSDictionary*)dict;

+ (void) assginImageWithSource:(UIImageView*)target  source:(NSString*)source;

+ (void)storeUserAccountInfo:(NSDictionary*) dict;

+ (NSDictionary*)loadUserAccountInfo;

+ (void)showRestResponseErrorMessage:(NSDictionary*)response;

+ (void)notifyCartUpdate:(NSString*)count;
@end
