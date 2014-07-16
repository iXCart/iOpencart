//
//  AppResource.m
//  icoco
//
//  Created by icoco on 22/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppResource.h"
#import "Lang.h"
#import "AppLanguage.h"


NSString * AppLocalizedString(NSString* key)
{
        NSString* value =[AppLanguage get:key alter:@""];
	//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil];
	
	if ( nil == value)
		return key;
	return value;
}

NSString * AppLocalizedString2(NSString* key, NSString* defaultValue)
{
    NSString* value =[AppLanguage get:key alter:defaultValue];
	//[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil];
	
	if ( nil == value)
		return key;
	return value;
}

#pragma mark get array from comma localizedString
NSArray*  AppLocalizedStringArray(NSString* key)
{
	NSString* value = [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil];
	
	if ( nil == value)
		return nil;
	
	return [value  componentsSeparatedByString: @","]; 
}



NSString * AppLocalizedResourcePathByKey(NSString* key)
{
	NSString* name = AppLocalizedString(key);
	NSString* value =[AppLanguage getPathForResource:name];
 	
	if ( nil == value)
		return key;
	return value;
}

NSString * AppLocalizedResourcePathByKeyWithSubDirectory(NSString* key,NSString* inDirectory)
{
	NSString* name = AppLocalizedString(key);
	NSString* value =[AppLanguage getPathForResource:name inDirectory:inDirectory];
 	
	if ( nil == value)
		return key;
	return value;
}


//////////////////////////////////////////////////////////////////
#pragma mark 
NSObject *AppResourceGet( NSString* aKey, NSObject* defaultValue)
{ 
	NSString * key = (NSString* )aKey;
	
	NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
	NSObject* value = (NSObject*)[settings objectForKey: key];
	if ( nil == value || nil != defaultValue)
	{
		[settings setObject:defaultValue forKey:key];
		value = defaultValue;
	}
	NSLog(@"key=[%@],value=[%@]", key, value );
	
	return value;
	
}
NSObject *AppResourceSet(const NSString* aKey,    NSObject* value)
{
	NSString * key = (NSString* )aKey;
	NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
	[settings setObject:value forKey:key];
	[settings synchronize];
	NSLog(@"key=[%@],value=[%@]", key, value );
	return value;
	
}
//////////////////////////////////////////////////////////////////

static AppResource *  appResInstance = nil;
@implementation AppResource
+(AppResource*) getInstance
{
	@synchronized(self)
	{
		if ( nil == appResInstance)
		{
			appResInstance = [[AppResource alloc ] init];
			
			//autorelease
			
		}
	}
	return appResInstance;
}


#pragma mark system invoked 
+ (void)initialize;
{	//@step 
	// [AppResource restoreDataBaseResouceFile];
}

//-(id) init
//{
//	[super init];
//	
//	return self ;
//}
//- (void)dealloc {
//	 
// 	[super dealloc];
//}




+(NSString*)getAppName
{
	return @"iApp";
}

+(NSMutableURLRequest*)assembleHTTPRequestHead:(NSMutableURLRequest *) requester
{
 	// These are the headers we need, we get ride of everything else
	NSArray *headers = [NSArray arrayWithObjects:
						@"User-Agent", nil];
	NSString* appName = [self getAppName];
	NSArray *values = [NSArray arrayWithObjects: appName, nil];
	
	// Add our headers
	for (NSString *header in headers) {
		// We use setValue to overwrite any value in an existing 
		// header, addValue appends to the values.
		id theValue =[values objectAtIndex:[headers indexOfObject:header]];
		[requester setValue:theValue forHTTPHeaderField:header ];
		
		NSLog( @"Added Header->%@,%@", header, theValue);
	}
	NSLog( @"Added Header->%@,%@", @"assembleHTTPRequestHead done", requester);
	
	return requester;
}

+(NSMutableURLRequest*)assembleHTTPRequestHeadFixed:(NSMutableURLRequest *) requester
{
	// These are the headers we need, we get ride of everything else
	NSArray *headers = [NSArray arrayWithObjects:@"Accept", 
						@"Content-type", @"Accept-Charset", 
						@"User-Agent", @"Host", @"Pragma", 
						@"Cache-Control", nil];
	NSArray *values = [NSArray arrayWithObjects:@"text/xml", @"xml/text", 
					   @"iso-8859-1,*,utf-8", @"Intrusion/1.0", 
					   [[requester URL] host], @"no-cache",
					   @"no-cache", nil];
	
	// Add our headers
	for (NSString *header in headers) {
		// We use setValue to overwrite any value in an existing 
		// header, addValue appends to the values.
		id theValue =[values objectAtIndex:[headers indexOfObject:header]];
		[requester setValue:theValue forHTTPHeaderField:header ];
		
		
		NSLog(@"Added Header: %@", header);
	}
	if (0) {
		// Remove every header but the ones we just added
		NSArray *allHeaders = [[requester allHTTPHeaderFields] allKeys];
		for (NSString *header in allHeaders) {
			if ([headers containsObject:header] == FALSE) {
				[requester setValue:nil forHTTPHeaderField:header];
				NSLog(@"Removed Header: %@", header);
			}
		}
		
	}
	
	NSLog(@"%@", [requester allHTTPHeaderFields]);
	return nil;
}
@end
