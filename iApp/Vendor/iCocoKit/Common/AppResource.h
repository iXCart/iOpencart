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
FOUNDATION_EXPORT NSArray*  AppLocalizedStringArray(NSString* key);

FOUNDATION_EXPORT NSString*  AppLocalizedResourcePathByKey(NSString* key);
FOUNDATION_EXPORT NSString*  AppLocalizedResourcePathByKeyWithSubDirectory(NSString* key, NSString* inDirectory);

///////////////////////////////////////////////////////////////////////////////////

FOUNDATION_EXPORT NSString *AppResourceGet(const  NSString* aKey,    const NSString* defaultValue);
FOUNDATION_EXPORT NSString *AppResourceSet( const NSString* aKey,    NSString* defaultValue);

///////////////////////////////////////////////////////////////////////////////////
@interface AppResource : NSObject {
	 
	 
 }

+(AppResource*) getInstance;
 
 
@end
