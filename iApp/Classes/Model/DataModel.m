//
//  DataModel.m
//  iApp
//
//  Created by icoco7 on 6/11/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (DataModel*)sharedInstance{
    
    static dispatch_once_t onceToken;
    static DataModel *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DataModel new];
    });
    return sharedInstance;
}

+ (void)getCategories
{
    
    
    // GET an Article and its Categories from /articles/888.json and map into Core Data entities
    // JSON looks like {"article": {"title": "My Article", "author": "Blake", "body": "Very cool!!", "categories": [{"id": 1, "name": "Core Data"]}
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
    
    
    RKEntityMapping *categoryMapping = [RKEntityMapping mappingForEntityForName:@"Category" inManagedObjectStore:managedObjectStore];
    [categoryMapping addAttributeMappingsFromDictionary:@{  @"name": @"name" }];
    if (0)
    {
        RKEntityMapping *articleMapping = [RKEntityMapping mappingForEntityForName:@"Article" inManagedObjectStore:managedObjectStore];
        [articleMapping addAttributeMappingsFromArray:@[@"title", @"author", @"body"]];
        [articleMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"categories" toKeyPath:@"categories" withMapping:categoryMapping]];
        
       
    }
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:categoryMapping method:RKRequestMethodAny pathPattern: nil keyPath:nil statusCodes:statusCodes];
    
    NSString* urlString = @"http://127.0.0.1/opencart/index.php?route=common/header&json";
    //urlString = @"http://127.0.0.1/opencart/json.php";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors: [NSArray arrayWithObject:responseDescriptor]];
    operation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    operation.managedObjectCache = managedObjectStore.managedObjectCache;
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
       // XCCategory *article = [result firstObject];
        NSLog(@"Mapped the result: %@", result);
        //  NSLog(@"Mapped the category: %@", [article.categories anyObject]);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    NSOperationQueue *operationQueue = [NSOperationQueue new];
    [operationQueue addOperation:operation];
}

- (void)add2Cart:(NSDictionary*)dict{
    if (nil == _localCart) {
        _localCart =[NSMutableArray array];
    }
    
    [_localCart addObject:dict];
}

- (NSArray*)getProudctsFromCart{
    return _localCart;
}
@end
