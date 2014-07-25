//
//  AppLanguage.m
//  iApp
//
//  Created by icoco on 01/05/2011.
//  Copyright 2011 icoco. All rights reserved.
//

#import "AppLanguage.h"
#import "Lang.h"

@implementation AppLanguage
 
static NSBundle * _bundle = nil;

+(void)setBuandle:(NSBundle *)value
{
	if (nil  != _bundle) {
		///[_bundle release];
		_bundle = nil;
	}
	//@step
	_bundle = value;
	if (nil != _bundle)
	{
		//[_bundle retain];
	}
 }
+(NSBundle*)getBuandle
{
	return _bundle;
}

 
+(NSString*)getSystemLanguage
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString *current =  [languages objectAtIndex:0]   ;
	return current;
}

+(void)initialize 
{
 	NSString *current =  [AppLanguage getSystemLanguage];
	[self setLanguage:current];
	
}
#pragma mark 
static NSString* _languageKey = nil;
+(void)setLanguageDesignation:(NSString *)l
{
	if (nil  != _languageKey) {
		//[_languageKey release];
		_languageKey = nil;
	}
	//@step
	if ([Lang isEmptyString:l]) {
		return;
	}
	_languageKey = [NSString stringWithFormat:@"%@", l]; 
	//[_languageKey retain];
}
+(NSString*)getLanguageDesignation
{
	return _languageKey;
}
/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 en
 fr
 For a complete list of ISO 639-1 and ISO 639-2 codes, go to http://www.loc.gov/standards/iso639-2/php/English_list.php.
 
 */
+(void)setLanguage:(NSString *)l {
	NSLog(@"preferredLang: %@", l);
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	if (nil == path) {
		return;
	}
	//@step
	NSBundle* theBundle = [NSBundle bundleWithPath:path];
	if (nil == theBundle) {
		return;
	}
	 //@step
	[self setBuandle:theBundle];
	//@step
	[self setLanguageDesignation:l];
	
}

- (NSBundle*)getActiveBundle
{
    if (nil ==_bundle) {
        _bundle = [NSBundle mainBundle];
    }
    return _bundle;
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate 
{
    if (nil ==_bundle) {
        _bundle = [NSBundle mainBundle];
    }
	return [ _bundle  localizedStringForKey:key value:alternate table:nil];
}

+(NSString*) getPathForResource:(NSString*) name
{
	
	NSString* result =[_bundle pathForResource: name ofType: nil];

	NSLog( @"name=%@,result=%@", name, result);
	return result;
	//[bundle pathForResource: name ofType:nil inDirectory:nil forLocalization:_LanguageKey] ;

 
}

+(NSString*) getPathForResource:(NSString*) name  inDirectory:(NSString*) inDirectory
{
	
	NSString* result =[_bundle pathForResource: name ofType:nil inDirectory:inDirectory ];
	
	NSLog( @"name=%@,result=%@", name, result);
	return result;
 	
	
}

@end
