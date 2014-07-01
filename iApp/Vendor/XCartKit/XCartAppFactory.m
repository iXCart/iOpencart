//
//  XCartAppFactory.m
//  iApp
//
//  Created by icoco7 on 6/25/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "XCartAppFactory.h"
#import "OpenCartUser.h"

@implementation XCartAppFactory

+ (XCartUser*) createUser:(id) context
{
    NSDictionary* response = (NSDictionary*)context;
    OpenCartUser* user = [[OpenCartUser alloc]initWithResponse:response];
    return user;
}

@end
