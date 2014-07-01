//
//  Utils.m
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString*) getBundleFileAsFullPath :(NSString*) fileName
{
	
	NSString* path = [  [NSBundle mainBundle] pathForResource: fileName ofType:nil];
    
	return path ;
}


@end
