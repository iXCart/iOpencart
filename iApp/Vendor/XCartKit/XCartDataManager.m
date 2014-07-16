//
//  XCartDataManager
//  iApp
//
//  Created by icoco7 on 6/12/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "XCartDataManager.h"
#import "XBlockBinder.h"
#import "XCartAppFactory.h"

static XCartDataManager* _sharedManager;

@interface XCartDataManager ()

- (void)setActiveUser:(XCartUser *)activeUser;

@end

@implementation XCartDataManager
 
+ (RKManagedObjectStore*) createCoreDataModelStore{
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSLog(@"%@",[managedObjectStore.managedObjectModel entitiesByName]);
    
    NSError *error = nil;
    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
    if (! success) {
        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
    }
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (! persistentStore) {
        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
    }
    [managedObjectStore createManagedObjectContexts];
    
    return managedObjectStore;
    //@step
}




+ (instancetype)sharedInstance{
    
    if (nil == _sharedManager) {
        _sharedManager = [[XCartDataManager alloc]init];
        [_sharedManager setupWorkSpace];
    }
    return _sharedManager;
}

///////////////////////////////////////////////////////////////////////
/*
 @request:
 
 @response:
 
 */
- (void)executeAction:(NSString*)urlString method:(RKRequestMethod)method  params:(NSDictionary*) params success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    int iMax = [params count];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:iMax];
    [parameters addEntriesFromDictionary:params];
    [parameters setObject:@"1" forKey:Rest_json];
    //@step
    
    //@step
    switch (method) {
        case RKRequestMethodGET:
            [_objectManager  getObject:nil path:urlString parameters:parameters  success:success failure:failure];
            break;
        case RKRequestMethodPOST:
            [_objectManager  postObject:nil path:urlString parameters:parameters  success:success failure:failure];
            break;
            
        default:
            assert(@"no matched support method! ");
            break;
    }
    
    
}


- (void)setupWorkSpace{
    
    
    RKManagedObjectStore * managedObjectStore = [XCartDataManager createCoreDataModelStore];
    
    NSString* baseURLString = [Resource getBaseURLString];
    // Configure the object manager
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString: baseURLString]];
    objectManager.managedObjectStore =  managedObjectStore;
    
    [RKObjectManager setSharedManager:objectManager];
    
    //@step
    _objectManager = objectManager;
    _managedObjectStore = objectManager.managedObjectStore;
    
    NSLog(@"%@->setupWorkSpace,RKObjectManager=[%@]",self,_objectManager);
}

#pragma mark Categories

- (void)setCategoriesResponseDescriptor{
    
    //@step
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Category" inManagedObjectStore:_managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:@{
                                                 @"name": @"name" ,
                                                 @"href": @"href"
                                                  }];
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern: nil keyPath:nil statusCodes:statusCodes];
    
     [_objectManager addResponseDescriptor:responseDescriptor];
    
    
}

+ (NSString*)getCategoryID:(NSManagedObject*)record{

    NSString* link = [record valueForKey:@"href"];
    NSRange range = [link rangeOfString:@"path=" ];
    NSString* categoryID = [link substringFromIndex: range.location + range.length];
    
    return categoryID;
}

+ (RKMappingResult*)formatCategoriesResult:(RKMappingResult*)mappingResult{
    
    if (nil == mappingResult || [mappingResult count]<=0) {
        return mappingResult;
    }
    
    NSArray* values = [mappingResult array];
    int iMax = [values count];
    
    for (int i= 0; i< iMax; i++) {
        NSManagedObject* item = [values objectAtIndex:i];
        NSString* categoryID = [XCartDataManager getCategoryID:item];
        [item setValue:categoryID forKey:@"key"];
        
        NSString* name = [item valueForKey:@"name"];
        name=[name stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        [item setValue:name forKey:@"name"];
        
       // [dict setObject:item forKey:categoryID];
    }
    
    RKMappingResult* result = mappingResult ;//[[RKMappingResult alloc] initWithDictionary:dict];
    return result;
}

/*
 *@request: @"h ttp://127.0.0.1/opencart/index.php?route=common/header&json"
 *
 *@response: {"name":"Desktops","column":"1","href":"http:\/\/127.0.0.1\/opencart\/index.php?route=product\/category&amp;path=20", 
        "children":[{"name":"PC (0)","href":"http:\/\/127.0.0.1\/opencart\/index.php?route=product\/category&amp;path=20_26"},{"name":"Mac (1)","href":"http:\/\/127.0.0.1\/opencart\/index.php?route=product\/category&amp;path=20_27"}] }
 */
- (void)getCategories:(NSDictionary*)parameters success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    [self setCategoriesResponseDescriptor];
    
    
    NSString* path = [Resource getCategoriesURLString];
    path = StringJoin(path, @"&json=1");
    
  //@  [_objectManager getObjectsAtPath: path parameters:nil  success:success failure:failure];
    //@step
    XBlockBinder* binder = [[XBlockBinder alloc]init];
    [binder setCompletionBlockWithSuccess:success failure:failure];
    [self putBlock:binder];
    __weak  XBlockBinder *weakSelf = binder;
    //@step
    
    [_objectManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        RKMappingResult* result = [XCartDataManager formatCategoriesResult:mappingResult];
        
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        strongSelf.success(operation, result);
     
        [strongSelf free];
        strongSelf = NULL;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        strongSelf.failure(operation,error);
        [strongSelf free];
        strongSelf = NULL;
    }];

}





#pragma mark Products
- (void)setProductResponseDescriptor{
    
    //@step
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"Product" inManagedObjectStore:_managedObjectStore];
    [entityMapping addAttributeMappingsFromDictionary:
                @{@"product_id":@"product_id",
                  @"name"  : @"name",
                  @"thumb" : @"thumb",
                  @"price" : @"price",
                  @"tax"   : @"tax",
                  @"note" :@"description"
                  }];
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern: nil keyPath:nil statusCodes:statusCodes];
    
    [_objectManager addResponseDescriptor:responseDescriptor];
    
    
}

//@request h-ttp://127.0.0.1/opencart/index.php?route=product/category&path=20&json

- (void)getProductsByCategoryId:(NSString*)categoryId    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
            failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
      NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"product/category",@"route", @"1",@"json",
                                  categoryId,@"path",
                                  nil];
    //@step
    
    [self setProductResponseDescriptor];
    //@step
    NSString* urlString = [Resource getProductsURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}


#pragma mark ProductDetails
/*
  @request: h-ttp://127.0.0.1/opencart/index.php?route=product/product&product_id=42&json
  @response:
*/
- (void)getProductDetailsById:(NSString*)productId    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"product/product",@"route", @"1",@"json",
                                productId,@"product_id",
                                nil];
    //@step
    
    [self setProductResponseDescriptor];
    //@step
    NSString* urlString = [Resource getProductsURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}

#pragma mark block container
- (void)putBlock:(XBlockBinder*)binder{
    
    if (nil == _blockContiner) {
        _blockContiner = [[NSMutableArray alloc]init];
    }
    [_blockContiner addObject:binder];
    binder.owner = _blockContiner;
     
}

- (void)setActiveUser:(XCartUser *)activeUser{
    if (activeUser != _activeUser) {
        _activeUser = nil;
    }
    
    _activeUser = activeUser;
}

#pragma mark User
- (void)setUserResponseDescriptor{
    
    //@step
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:_managedObjectStore];
    
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:entityMapping method:RKRequestMethodAny pathPattern: nil keyPath:nil statusCodes:statusCodes];
    
    [_objectManager addResponseDescriptor:responseDescriptor];
    
    
}

#pragma mark Login
/*
 @request: h ttp://127.0.0.1/opencart/index.php?route=account/login
    method="post" enctype="multipart/form-data">
 @response:
 */
- (void)login:(NSString*)email pasword:(NSString*)password    success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    if ([Lang isEmptyString:password]|| [Lang isEmptyString:email]) {
        return;
    }
    //@step
    [self setUserResponseDescriptor];
    //@step
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:  @"1",@"json",
                                email,@"email",
                                password,@"password",
                                nil];
    //@step
    XBlockBinder* binder = [[XBlockBinder alloc]init];
    [binder setCompletionBlockWithSuccess:success failure:failure];
    [self putBlock:binder];
     __weak  XBlockBinder *weakBinder = binder;
    
    //@step
    NSString* path = [Resource getLoginURLString];
     [_objectManager postObject:nil path:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         
         //@step
         NSData* data = operation.HTTPRequestOperation.responseData;
         NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary:data];
         
         XCartUser* user = [XCartAppFactory createUser:response];
         [[XCartDataManager sharedInstance] setActiveUser:user];
         //@step
         __strong __typeof(&*weakBinder)strongSelf = weakBinder;
        
         strongSelf.success(operation, mappingResult);
        
         [strongSelf free];
         strongSelf = NULL;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        XCartUser* user = [XCartAppFactory createUser:nil];
        [[XCartDataManager sharedInstance] setActiveUser:user];
        
        __strong __typeof(&*weakBinder)strongSelf = weakBinder;

        strongSelf.failure(operation,error);
        [strongSelf free];
        strongSelf = NULL;
    }];
}

- (void)logout:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    if (self.activeUser == nil) {
        return;
    }
    //@step
    
    //@step
    XBlockBinder* binder = [[XBlockBinder alloc]init];
    [binder setCompletionBlockWithSuccess:success failure:failure];
    [self putBlock:binder];
    __weak  XBlockBinder *weakBinder = binder;
    
    //@step
    NSString* urlString = [Resource getLogoutURLString];
     [self executeAction:urlString method:RKRequestMethodGET params:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        //@step
        NSData* data = operation.HTTPRequestOperation.responseData;
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary:data];
        
         if (nil == response) {
             return  ;
         }
         if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
         {
          
             [self setActiveUser:nil];
         }else
         {
             [Resource showRestResponseErrorMessage:response];
         }

        //@step
        __strong __typeof(&*weakBinder)strongSelf = weakBinder;
        
        strongSelf.success(operation, mappingResult);
        
        [strongSelf free];
        strongSelf = NULL;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        
        __strong __typeof(&*weakBinder)strongSelf = weakBinder;
        
        strongSelf.failure(operation,error);
        [strongSelf free];
        strongSelf = NULL;
    }];
}


#pragma mark checkout cart


/*
 @request: h－ttp://127.0.0.1/opencart/index.php?route=checkout/cart&json
 @response:
 */
- (void)getCart: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/cart",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}


 
/*
 @request: h－ttp://127.0.0.1/opencart/index.php?route=checkout/payment_address&json
 @response:
 */
- (void)getPaymentAddress: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
        failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/payment_address",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}

/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/payment_address/save
 @response:
 */
- (void)savePaymentAddress:(NSDictionary*) params success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    int iMax = [params count];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:iMax];
    [parameters addEntriesFromDictionary:params];
    [parameters setObject:@"1" forKey:Rest_json];
    //@step
    
    //@step
    NSString* urlString = StringJoin([Resource getCartURLString],@"route=checkout/payment_address/save") ;
    
    [_objectManager  postObject:nil path:urlString parameters:parameters  success:success failure:failure];
}



/*
 @request: h-ttp://127.0.0.1/opencart/index.php?route=checkout/shipping_address&json
 @response:
 */
- (void)getShippingAddress: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/shipping_address",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}


/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/shipping_address/save
 @response:
 */
- (void)saveShappingAddress:(NSDictionary*) params success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    int iMax = [params count];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:iMax];
    [parameters addEntriesFromDictionary:params];
    [parameters setObject:@"1" forKey:Rest_json];
    //@step
    
    //@step
    NSString* urlString = StringJoin([Resource getCartURLString],@"route=checkout/shipping_address/save") ;
    
    [_objectManager  postObject:nil path:urlString parameters:parameters  success:success failure:failure];
}



/*
 @request: h-ttp://127.0.0.1/opencart/index.php?route=checkout/shipping_method&json
 @response:
 */
- (void)getShippingMethod: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/shipping_method",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}


/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/shipping_method/save
 @response:
 */
- (void)saveShappingMethod:(NSDictionary*) params success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                    failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    int iMax = [params count];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:iMax];
    [parameters addEntriesFromDictionary:params];
    [parameters setObject:@"1" forKey:Rest_json];
    //@step
    
    //@step
    NSString* urlString = StringJoin([Resource getCartURLString],@"route=checkout/shipping_method/save") ;
    
    [_objectManager  postObject:nil path:urlString parameters:parameters  success:success failure:failure];
}


/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/payment_method
 @response:
 */
- (void)getPaymentMethod: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/payment_method",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}

/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/payment_method/save
 @response:
 */
- (void)savePaymentMethod:(NSDictionary*) params success: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                   failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    int iMax = [params count];
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:iMax];
    [parameters addEntriesFromDictionary:params];
    [parameters setObject:@"1" forKey:Rest_json];
    //@step
    
    //@step
    NSString* urlString = StringJoin([Resource getCartURLString],@"route=checkout/payment_method/save") ;
    
    [_objectManager  postObject:nil path:urlString parameters:parameters  success:success failure:failure];
}


/*
 @request: h ttp://127.0.0.1/o2/index.php?route=checkout/confirm&json
 @response:
 */
- (void)getCheckoutConfirmMethod: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                 failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure{
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys: @"checkout/confirm",@"route", @"1",@"json",
                                
                                nil];
    //@step
    
    //@step
    NSString* urlString = [Resource getCartURLString];
    
    [_objectManager getObjectsAtPath:urlString parameters:parameters  success:success failure:failure];
}







@end
