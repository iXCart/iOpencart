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
}

+ (DataModel*)sharedInstance;


- (void)add2Cart:(NSDictionary*)dict;
- (NSArray*)getProudctsFromCart;

@end
