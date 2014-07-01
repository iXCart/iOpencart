//
//  XCartUser.h
//  iApp
//
//  Created by icoco7 on 6/25/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface XCartUser : NSObject


@property(nonatomic)NSString* userId;
@property(nonatomic)NSString* email;
@property(nonatomic)NSString* pasword;

@property(nonatomic,readonly)NSDictionary* response;

-(id)initWithResponse:(NSDictionary*)response;

-(BOOL)isValidateUser;

@end
