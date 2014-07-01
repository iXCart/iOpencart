//
//  OpenCartUser.m
//  iApp
//
//  Created by icoco7 on 6/25/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "OpenCartUser.h"

@implementation OpenCartUser

@synthesize response = _response;

-(id)initWithResponse:(NSDictionary*)response
{
    self = [super init];
    _response = response;
    return self;
}

-(BOOL)isLoginSuccessResponse:(NSDictionary*)response
{
    if (nil == response) {
        return false;
    }
    NSString* error_warning = [response valueForKey:Account_error_warning];
    if (![Lang isEmptyString:error_warning]) {
        return false;
    }
    NSString* success = [response valueForKey:Account_success];
    if (nil == success || ![success isEqualToString:@""]) {
        return false;
    }
    //@step the success should set and eaual ''
    return true;
    
}

-(BOOL)isValidateUser
{
    return [self isLoginSuccessResponse:_response];
}
@end
