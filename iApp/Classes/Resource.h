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

@interface Resource : NSObject


+(UIColor*) getStandardColor;
 
+ (NSString*) getBaseURLString;

+ (NSString*)getIndexURLString;

+ (NSString*)getProductsURLString; 

+ (NSString*)getLoginURLString;

+ (NSArray*)getImagesDefsFromProductResult:(NSDictionary*)dict;

+ (void) assginImageWithSource:(UIImageView*)target  source:(NSString*)source;

@end
