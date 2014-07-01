//
//  AppLanguage.h
//  iApp
//
//  Created by icoco on 01/05/2011.
//  Copyright 2011 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSString* _FrenchLanguageCode =@"fr";
const static NSString* _EnglishLanguageCode =@"en";

@interface AppLanguage : NSObject {

}
 
+(void)setLanguage:(NSString *)l ;
+(NSString*)getLanguageDesignation;


+(NSString *)get:(NSString *)key alter:(NSString *)alternate ;
+(NSString*) getPathForResource:(NSString*) name;

+(NSString*) getPathForResource:(NSString*) name  inDirectory:(NSString*) inDirectory;

@end
