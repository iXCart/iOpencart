//
//  Lang.h
//  LocateMe
//
//  Created by icoco on 31/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
#define ICOCOKIT_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define ICOCO_EXTERN	        extern __attribute__((visibility ("default")))
#endif

#define ICOCOKIT_STATIC_INLINE	static inline
#define	ICOCOKIT_EXTERN_CLASS	__attribute__((visibility("default")))
///////////////////////////////////////////////////////////////////////////

FOUNDATION_EXPORT     NSString* CTString( const NSString*);
FOUNDATION_EXPORT    NSString*   StringJoin(  NSString*  aString  ,  NSString*   bString);
FOUNDATION_EXPORT    BOOL    StringEqual(const  NSString*  aString  ,  const NSString*   bString);

///////////////////////////////


// This protocol is used to tell the root view to flip between views
@protocol ObserverDelegate <NSObject>
@required
-(void)update:(id)sender  value :(id) value;
@optional
-(id)onCallBack:(id)sender  value :(id) value;

@end

static const NSString* _TRUE = @"TRUE";
static const NSString* _FALSE = @"FALSE";
static const NSString* _TRUE_ONE= @"1";
static const NSString* _FALSE_ZERO = @"0";


#pragma Lang
@interface Lang : NSObject {

}


+ (BOOL) isEmptyString:(NSString*) value;
+ (BOOL) isContainsString:(const NSString*) value   token:(const NSString*) token;
+ (NSString*)safeString:(NSString*) value   toValue:(NSString*) toValue;

+ (NSString*) trimString:(NSString*) value;

+ (NSString*)safeNumberToIntString:(NSNumber*) value   toValue:(NSString*) toValue;

+ (float)safeStringToFloat:(NSString*)value toValue:(float)toValue;

+ (NSString*) toBoolString:(BOOL) value;

+ (BOOL) toBool:( NSString*) value;

+ (id)paseJSONDatatoArrayOrNSDictionary:(NSData *)jsonData;
@end
