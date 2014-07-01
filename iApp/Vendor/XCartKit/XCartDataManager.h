//
//  XCartDataManager
//  iApp
//
//  Created by icoco7 on 6/12/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBlockBinder.h"
#import "XCartUser.h"

@interface XCartDataManager : NSObject{
    
    RKObjectManager* _objectManager;
    RKManagedObjectStore* _managedObjectStore;
    
    NSMutableArray* _blockContiner;
  
    XCartUser* _activeUser;
}

@property(nonatomic,readonly)XCartUser* activeUser;


+ (instancetype)sharedInstance;


- (void)getCategories:(NSDictionary*)parameters success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)getProductsByCategoryId:(NSString*)categoryId    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)getProductDetailsById:(NSString*)productId    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

- (void)login:(NSString*)email pasword:(NSString*)password    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
