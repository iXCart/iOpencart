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

@implementation Resource


+(UIColor*) getStandardColor
{
 	
	return [UIColor colorWithRed:0/255.0 green:142/255.0 blue:94.0/255.0 alpha:1.0];
	
	 
}  

+ (NSString*) getBaseURLString
{
    return NSLocalizedString(@"WebSerivceEntry",@"");
    return @"http://127.0.0.1/";
    
    
}

+ (NSString*)getIndexURLString
{
    return @"/opencart/index.php?";
}



+ (NSString*)getProductsURLString
{
  return @"/opencart/index.php?";
 
}

+ (NSString*)getLoginURLString
{
    return @"/opencart/index.php?route=account/login";
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


@end
