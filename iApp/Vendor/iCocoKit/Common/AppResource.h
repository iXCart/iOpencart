//
//  AppResource.h
//  iCoco
//
//  Created by icoco on 22/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark localestring 
FOUNDATION_EXPORT NSString*  AppLocalizedString(NSString* key);
FOUNDATION_EXPORT NSString*  AppLocalizedString2(NSString* key, NSString* defaultValue);

FOUNDATION_EXPORT NSArray*  AppLocalizedStringArray(NSString* key);

FOUNDATION_EXPORT NSString*  AppLocalizedResourcePathByKey(NSString* key);
FOUNDATION_EXPORT NSString*  AppLocalizedResourcePathByKeyWithSubDirectory(NSString* key, NSString* inDirectory);

///////////////////////////////////////////////////////////////////////////////////

FOUNDATION_EXPORT NSObject *AppResourceGet(const  NSString* aKey,    const NSObject* defaultValue);
FOUNDATION_EXPORT NSObject *AppResourceSet( const NSString* aKey,    NSObject* defaultValue);

///////////////////////////////////////////////////////////////////////////////////
@interface AppResource : NSObject {
	 
	 
 }

+(AppResource*) getInstance;
 
 
@end
