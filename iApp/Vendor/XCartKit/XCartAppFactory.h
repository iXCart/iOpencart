//
//  XCartAppFactory.h
//  iApp
//
//  Created by icoco7 on 6/25/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCartUser.h"

@interface XCartAppFactory : NSObject

+ (XCartUser*) createUser:(id) context;

@end
