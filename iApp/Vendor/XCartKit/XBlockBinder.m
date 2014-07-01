//
//  XBlockBinder.m
//  iApp
//
//  Created by icoco7 on 6/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "XBlockBinder.h"

@implementation XBlockBinder

@synthesize success = _success;
@synthesize successHook = _successHook;

@synthesize failure = _failure;
@synthesize failureHook = _failureHook;
 
 
#pragma bridge
- (void)setCompletionBlockWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                             failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
   
    if (success != _success) {
        _success = NULL;
        _success = nil;
    }
    if (success) {
        _success = [success copy];
    }
    //@step
    if (failure != _failure) {
        _failure = NULL;
        _failure = nil;
    }
    if (failure) {
        _failure = [failure copy];
    }

    
}
 
- (void)setHookCompletionBlockWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
{
    
    if (success != _successHook) {
        _successHook = NULL;
        _successHook = nil;
    }
    if (success) {
        _successHook = [success copy];
    }
    //@step
    if (failure != _failureHook) {
        _failureHook = NULL;
        _failureHook = nil;
    }
    if (failure) {
        _failureHook = [failure copy];
    }
    
    
}

- (void)free
{

    if (nil != self.owner) {
        NSMutableArray* array = (NSMutableArray*)self.owner;
        
        for (NSObject* item in array) {
            if (item == self) {
                [array removeObject:item];
                break;
            }
        }
        
    }
    
}

- (void)freeBolck:(XBlock)block
{
    block = NULL;
    block = nil;

}
- (void)dealloc
{
    NSLog(@"%@->dealloc",self);
    [self freeBolck:_success];
    [self freeBolck:_successHook];
    [self freeBolck:_failure];
    [self freeBolck:_failureHook];
    
}

@end
