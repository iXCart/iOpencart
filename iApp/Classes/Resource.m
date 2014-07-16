//
//  Resource.m
//  iCart
//
//  Created by icoco7 on 5/21/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import "Resource.h"
#import "PageControllerKit.h"
#import "UIImageView+WebCache.h"

NSString* NotifyEventCommpleteAddCart =@"NotifyEventCommpleteAddCart";

@implementation Resource


+(UIColor*) getStandardColor
{
 	
	return [UIColor colorWithRed:0/255.0 green:142/255.0 blue:94.0/255.0 alpha:1.0];
	
	 
}  

+ (NSString*) getBaseURLString
{
    return  AppLocalizedString2(@"WebSerivceEntry",@"http://127.0.0.1/o2");
    
    return @"http://127.0.0.1/opencart";
    return @"http://127.0.0.1/o2";
    
    
}

+ (NSString*)getIndexURLString
{
    return StringJoin([Resource getBaseURLString],    @"/index.php?");
    
}


+ (NSString*)getCategoriesURLString
{
    return StringJoin([Resource getBaseURLString],    @"/index.php?route=common/header");
    
}

+ (NSString*)getProductsURLString
{
    return StringJoin([Resource getBaseURLString],    @"/index.php?");
  
}

+ (NSString*)getLoginURLString
{
     return StringJoin([Resource getBaseURLString],    @"/index.php?route=account/login");
    return @"/opencart/index.php?route=account/login";
}


+ (NSString*)getCartURLString
{
    return StringJoin([Resource getBaseURLString],    @"/index.php?");
    
}

+ (NSString*)getAddCartURLString
{
    return StringJoin([Resource getIndexURLString], @"route=checkout/cart/add");
}

+ (NSString*)getPaymentConfirmURLString
{
    return StringJoin([Resource getIndexURLString], @"route=payment/cod/confirm");
}

+ (NSString*)getCheckoutSuccessURLString
{
    return StringJoin([Resource getIndexURLString], @"route=checkout/success");
} 

+ (NSString*)getLogoutURLString
{
    return StringJoin([Resource getIndexURLString], @"route=account/logout");
}


+ (NSDictionary*)dictonaryWithImagePair:(NSString*)name value:(NSString*)value{
    
   NSDictionary* result = [NSDictionary dictionaryWithObjectsAndKeys:
     name, kPageNameKey, value, kPageSourceKey, nil];
    
    return  result;
}

+ (NSArray*)getImagesDefsFromProductResult:(NSDictionary*)dict
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* name = Product_popup;
    NSString* value =[dict valueForKey:name];
    if ([Lang isEmptyString:value]) {
        return nil;
    }
    NSDictionary* item = [Resource dictonaryWithImagePair:name value:value];
    
    [result addObject:item];
    //@step
    NSArray* images = [dict valueForKey:Product_images];
    
    if (nil == images || [images count]<=0) {
        return result;
    }
    //@step
    for(NSDictionary* item in images){
        NSString* name = Product_popup;
        NSString* value =[item valueForKey:name];
        //@step
        if ([Lang isEmptyString:value]) {
            continue;
        }
        NSDictionary* item = [Resource dictonaryWithImagePair:name value:value];
        
        [result addObject:item];
    }
    return result;
};

+ (void) assginImageWithSource:(UIImageView*)target  source:(NSString*)source{
    
    //@TODO:
    [ target sd_setImageWithURL:[NSURL URLWithString: source] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}


+ (void)storeUserAccountInfo:(NSDictionary*) dict{
    AppResourceSet(@"App.UserAccount.Info", dict);
}

+ (NSDictionary*)loadUserAccountInfo{
    return (NSDictionary*)AppResourceGet(@"App.UserAccount.Info", nil);
}

+ (NSString*)fomratDictionary2String:(NSDictionary*)dict
{
    if (nil == dict) {
        return @"";
    }
    NSString* result =@"";
    NSArray* keys = [dict allKeys];
    int iMax = [keys count];
    for (int i=0; i< iMax; i++) {
        NSString* key = [keys objectAtIndex:i];
        NSString* value = [dict valueForKey:key];
        
        result = [NSString stringWithFormat:@"%@\n%@:%@", result,key,value];
    }
    return result;
}
#pragma mark showRestResponseErrorMessage
+ (void)showRestResponseErrorMessage:(NSDictionary*)response{
    
    NSString* message =@"";
    do {
        NSDictionary* data = [response valueForKey:Rest_json];
        if (nil != data) {
            NSDictionary* error = [data valueForKey:Rest_error];
            message = [error valueForKey:Rest_warning];
            break;
        }
        //@step
        data = [response valueForKey:Rest_data];
        if (nil != data) {
            NSDictionary* error = [data valueForKey:Rest_error];
           // message = [error valueForKey:Rest_warning];
           // if (nil == message) {
                //@case Failed add cart.
                message = [Resource fomratDictionary2String:error];
          //  }
            break;
        }
        if (nil == data) {
            message = [response description];
        }
    }while(false);
     
    [CDialogViewManager showMessageView:@"" message:message delayAutoHide:-1];
}

/*
 
 @Input: Success: You have added <a href="http://127.0.0.1/o2/index.php?route=product/product&amp;product_id=40">iPhone</a> to your <a href="http://127.0.0.1/o2/index.php?route=checkout/cart">shopping cart</a>!

 @Output: Success: You have added to your shopping cart!

 */

+ (NSString*)trimHTMLString:(NSString*)htmlString
{
    if ([Lang isEmptyString:htmlString]) {
        return htmlString;
    }
    NSString* beginMark = @"<"; NSString* endMark = @">";
    
    NSString* temp = htmlString;
    
    NSRange range =  [ temp rangeOfString:beginMark];
    if (0 == range.length) {
        return htmlString;
    }
   // temp = [temp substringFromIndex:<#(NSUInteger)#>
    return nil;
}

/*
 @input: possible : '13 item(s) - $1,567.60', then need convert to correct number
 */
+ (void)notifyCartUpdate:(NSString*)count
{
    int i = [count intValue];
    count = i >0 ?  [NSString stringWithFormat:@"%d", i] : @"";
    //@step
    NSDictionary* notifyData = [NSDictionary dictionaryWithObjectsAndKeys:count,@"count", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotifyEventCommpleteAddCart object:notifyData];
}


@end
