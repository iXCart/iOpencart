//
//  CUIEnginer.m
//  iApp
//
//  Created by icoco7 on 6/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CUIEnginer.h"
#import "CNavigationController.h"

@implementation CUIEnginer



+(UIViewController*)createViewController:(NSString*) className inNavigationController :(BOOL) inNavigationController
{
    UIViewController* result = nil;
    
	Class class = NSClassFromString(className);
    UIViewController *viewController   = [class new];
    viewController = [viewController initWithNibName:className bundle:nil];
    //@step
    if (inNavigationController) {
        CNavigationController* nav =[ [CNavigationController alloc] initWithRootViewController:viewController];
        result = nav;
    }else
        result = viewController;
	
    
	return result;
}

#pragma mark UITabController;
+(UIViewController*) viewController4Tab:(NSDictionary*)data
{
	NSString* type = [data valueForKey:@"Class"];
 	//@step
    
    //@step
    UIViewController* viewController = [CUIEnginer createViewController:type inNavigationController:true];
    if (nil == viewController)
    {
        
        return viewController;
    }
    NSString* title = [data valueForKey:@"Name"];
    NSString* imageName = [data valueForKey:@"Image"];
    
    
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed: imageName];
    viewController.title = title;
    return viewController;
    
}




+(NSArray*) getTabViewControllersWithCfg:(NSString*)cfgFilePath
{
	NSArray* data = [NSArray arrayWithContentsOfFile:cfgFilePath];
	if (nil == data || [data count]<=0) {
		NSLog(@"Miss read data from->[%@]", cfgFilePath);
		return nil;
	}
    
    //@step
	int iMax = [data count];
	//@step
	NSMutableArray*  tabs = [NSMutableArray arrayWithCapacity:iMax];
	//@step init a list for replace it in next step
	for (int i=0; i< iMax; i++) {
		[tabs addObject:@""];
	}
	//@step
    for (int i=0; i< iMax; i++) {
        
        NSDictionary* item = [data objectAtIndex:i];
        UIViewController* itemViewController = [CUIEnginer viewController4Tab:item];
		if (nil == itemViewController) {
			continue;
		}
        
        /*
         //@step
         NSString* type = [item valueForKey:@"Type"];
         NSString* order = [item valueForKey:@"ID"];
         NSString* strOrder = AppResourceGet(type, order);
         int iAt = [strOrder intValue];
         [tabs replaceObjectAtIndex:iAt withObject: itemViewController];
         */
        [tabs replaceObjectAtIndex:i withObject: itemViewController];
        
	}
    
    
	return tabs;
	
}



@end
