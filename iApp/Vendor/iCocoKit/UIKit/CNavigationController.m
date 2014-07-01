//
//  CNavigationController.m
//  icoco
//
//  Created by icoco on 30/10/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CNavigationController.h"
#import "Lang.h"
#import "Resource.h"
@implementation CNavigationController

-(UIColor*) getStandardColor 
{
	//return [UIColor colorWithRed:180.0/255.0 green:9.0/255.0 blue:15.0/255.0 alpha:1.0];
	return [Resource getStandardColor];
}  
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
			
		UIColor* color =[self getStandardColor]; 
		if ( nil != color)
			self.navigationBar.tintColor =  color;//Or any other color.
		
		//@step
		
		
	}
	return self;
}
- (id)initWithRootViewController:(UIViewController *)rootViewController  // Convenience method pushes the root view controller without animation.
{	self = [super initWithRootViewController:rootViewController];
	

	return self;
}
- (void)dealloc
{
	 
 
	 	
	///[super dealloc];
} 
 


@end
