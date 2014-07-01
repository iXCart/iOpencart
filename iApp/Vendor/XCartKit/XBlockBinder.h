//
//  XBlockBinder.h
//  iApp
//
//  Created by icoco7 on 6/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void  (^ XBlock)(id operation, id result) ;


@interface XBlockBinder : NSObject
{
    XBlock _success;
    XBlock _successHook;
    
    XBlock _failure;
    XBlock _failureHook;
}

@property (nonatomic, readonly) XBlock success;
@property (nonatomic, readonly) XBlock successHook;

@property (nonatomic, readonly) XBlock failure;
@property (nonatomic, readonly) XBlock failureHook;

@property (nonatomic, assign) id owner;



- (void)setCompletionBlockWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)setHookCompletionBlockWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)free;

@end
