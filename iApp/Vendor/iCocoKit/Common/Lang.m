//
//  Lang.m
//  LocateMe
//
//  Created by icoco on 31/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Lang.h"

#pragma NSString
//@purpose  convert constan string to  normal string
NSString* CTString( const NSString*  value)
{
	if ( nil == value) return nil;
	return [NSString stringWithFormat:@"%@", value];
}
 NSString*   StringJoin(  NSString*  aString  ,  NSString*   bString)
{
	aString =  [aString stringByAppendingFormat:@"%@",    bString];
	return aString;
}
BOOL    StringEqual( const NSString*  aString  ,  const NSString*   bString)
{
	if ( nil == aString && nil == bString) return TRUE;
	if ( nil == aString || nil == bString) return FALSE;
	
	return [aString isEqualToString:bString];
}
@implementation Lang


+(BOOL) isEmptyString:(NSString*) value
{
	 if (nil == value) {
		 return TRUE;
	 }
	BOOL bState = nil != value  &&  0  !=[value length ] 
				&&! [@""  isEqualToString:value] 
				&& ! [@"" isEqualToString:[value description]];
	
	return !bState;
	
}

+(BOOL) isContainsString:(const NSString*) value   token:(const NSString*) token
{	
	if ( nil == value ) return FALSE;
	if ( [value isEqualToString: token]) return TRUE;
	
	NSArray * items = [value  componentsSeparatedByString:token];
	BOOL bState = [items count] >=2 ;
	//[items release];
	
	return bState;
	
}
 
+(NSString*)safeString:(NSString*) value   toValue:(NSString*) toValue
{
	if ( nil == value) 
		return toValue;
	if (! [value isKindOfClass:[NSString class]])
		return toValue;
	if (nil == value  ||  [value length ] == 0)
		return toValue;
	return  [NSString stringWithFormat:@"%@", value];
}

+(NSString*)safeNumberToIntString:(NSNumber*) value   toValue:(NSString*) toValue
{
	if ( nil == value)
		return toValue;
    
    NSInteger i = [value integerValue];
    
    return [NSString stringWithFormat:@"%d", i];
    
}

//@input $1,177
//@output 1177
+ (float)safeStringToFloat:(NSString*)value toValue:(float)toValue
{
    if ([Lang isEmptyString:value]) {
        return toValue;
    }
    
    NSString* result = [value stringByReplacingOccurrencesOfString:@"$" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
    return [result floatValue];
    
    if ([Lang isContainsString:value token:@"$"]) {
        NSRange range = [value rangeOfString:@"$"];
        NSString* numberString = [value substringFromIndex: range.location + range.length];
        return [numberString doubleValue];
    }
    return [value doubleValue];
}

+(NSString*) trimString:(NSString*) value
{
	if (nil == value) {
		return value;
	}
	NSString *trimmedString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return  trimmedString;
	
}

+(BOOL)isTelphoneNumber:(NSString*)value
{  NSLog( @"isTelphoneNumber ?", value);
	BOOL result = FALSE;
	
	if (![Lang isFullNumber:value]) {
		
	}else {
		result = [value length]>=3;
	}
	NSLog(  @"isTelphoneNumber input=[%@] out=[%d]", value, result);
	return result;
}

+(BOOL) isWebUrlString:(NSString*)value
{
	if ([Lang isEmptyString:value]) {
		return FALSE;
	}
    
	value = [value lowercaseString];
	NSString* toke = @"http://";
    
	BOOL bState = [value hasPrefix: toke];
 	if (bState ) {
		return bState;
 	}
	//@step
 	toke = @"www.";
	
    bState = [value hasPrefix: toke];
 	if (bState ) {
		return bState;
 	}
	//@step
	return FALSE;
}

+(NSString*) toDoubleAsString:(double) value
{
	NSString* strValue=[NSString stringWithFormat:@"%f", value];
	return strValue;
	
}

#pragma mark split
+(NSMutableArray*)splitStringByCount:(NSString*) value  count: (int) count
{
	if ([Lang isEmptyString:value] ||  count <=0) 
	{
		return nil;
	}
	//@step
	NSMutableArray* array =[ [NSMutableArray alloc] initWithCapacity:count];
	 
	
	NSString * theValue = value;
	int length = [theValue length];
	int iFacotr = length / count ;
 
	//@step
	for (int i =0 ;  i < count;  i ++) 
	{
		int  iStart = iFacotr* i ;
		NSRange range = NSMakeRange(iStart ,  iFacotr) ;
		NSString*  subValue = [theValue substringWithRange:range];
		[array addObject:subValue];
	}
	//@step need append the last 
	int  upRound = [Lang upRound:length b:count];
	if(  iFacotr != upRound)
	{
		int iAt = iFacotr * count ;
		NSString*  subValue = [theValue substringFromIndex: iAt];
		[array addObject:subValue];
		
	}
	//@step
	return array;
}

#pragma mark HTTP
+(NSString*) getEncodeName: (NSString *)name base:(NSString *)base
{
	NSString* strUrl =[NSString stringWithString: base];
	strUrl = [ [strUrl stringByAppendingString:name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
	return strUrl;
}
+(NSURL*) toURL : (NSString *)aStringUrl
{
	
	NSURL *url = [NSURL URLWithString: aStringUrl]   ;
	
	return url;
}
+(NSURL*) getEncodeURL: (NSString *)name base:(NSString *)base
{
	NSString* strUrl = [Lang getEncodeName:name base:base];
	return [Lang toURL:strUrl];
}

+(NSString*) getShortNameByURL:(NSString*) urlName
{
	if ([Lang isEmptyString:urlName]) return urlName;
	
	if (! [urlName hasPrefix:@"http://"]) return urlName;
	
	return [urlName lastPathComponent];
}

#pragma mark 
+(NSString*) toArrayAsSubSql :( NSArray *) aArray 
{	NSString* sql = @"";
	
	int iSize = [aArray count];
	for (int i =0 ; i <iSize ; i ++) {
		NSString* value = (NSString*)[aArray objectAtIndex:i];
		if ( 0 == i)
		{
			sql = [NSString stringWithFormat:@"'%@'",  value];
		}
		else
		{
			sql = [NSString stringWithFormat:@"%@ ,'%@'", sql, value];
		}
		
	}
	return sql;
}

#pragma mark maths 
+(int ) upRound:(float) a   b:(float) b
{	
	NSString* msg = [NSString stringWithFormat:@"%f / %f", a, b ];
	 
	int i = a/b;
	float j = i * b ;
	j = a - j; 
	
	if ( j >0.0)
		i = i + 1;
	return i;
}

#pragma mark  size toString
+(NSString*) toCGRectString:(CGRect) aRect
{
	NSString* msg = [NSString stringWithFormat:@"x=%f,y=%f,width=%f,height=%f", aRect.origin.x, 
					aRect.origin.y, aRect.size.width, aRect.size.height];
	return msg;
}

#pragma mark uuid
+(NSString*) getGUID
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, uuid);
	NSString* value = [NSString stringWithFormat:@"%@", string];
	CFRelease(string);
	CFRelease(uuid);

	return value;
}

+(NSIndexPath*)  indexPathMake:(int) section  index:(int)index
{
	return [NSIndexPath  indexPathForRow:index inSection:section];
}
+(BOOL)isEqualIndexPath:(NSIndexPath*) a b:(NSIndexPath*) b
{
	if (nil ==a  && nil == b ) {
		return TRUE;
	}
	
	if (nil ==a || nil == b ) {
		return FALSE;
	}
	return a.row == b.row && a.section == b.section;
}


#pragma mark toDictionaryWithKeyValueString
//@purpose  "latitude=37.1&longitude=121.2"
+(NSDictionary*) toDictionaryWithKeyValueString:(NSString*) value
{
	if (nil == value) {
		return nil;
	}
 	NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
 
	NSArray* items = [value componentsSeparatedByString: @"&"];
	int iSize = [items count];
	for (int i =0; i < iSize; i ++) {
		NSString * item = [items objectAtIndex:i];
		NSArray*  keyAndValue = [item componentsSeparatedByString: @"="];
		if (nil != keyAndValue && [keyAndValue count] ==2) {
			NSObject* key = [keyAndValue objectAtIndex:0];
			NSObject* value = [keyAndValue objectAtIndex:1];
			
			[result setObject:value  forKey:key];
		}
		
	}
	//@step
	return result;
	
}

#pragma mark point
+(NSValue*) makePointToObject:(CGPoint*) point
{
	NSCoder *coder;
NSValue *pointValue = [NSValue value:&point withObjCType:@encode(CGPoint)];
[coder encodeObject:pointValue forKey:@"point"];
	return pointValue;
}
+(CGPoint*) makeObjectToPoint:(NSCoder*) value
{
	//NSCoder *decoder;
	NSValue *decodedValue = [value decodeObjectForKey:@"point"];
	CGPoint point;
	[decodedValue getValue:&point];
	return &point;
}
#pragma mark rect
+(NSValue*) makeRectToObject:(CGRect) rect
{
	NSCoder *coder;
	NSValue *pointValue = [NSValue value:&rect withObjCType:@encode(CGRect)];
	[coder encodeObject:pointValue forKey:@"rect"];
	return pointValue;
}
+(CGRect*) makeObjectToRect:(NSCoder*) value
{
	//NSCoder *decoder;
	NSValue *decodedValue = [value decodeObjectForKey:@"rect"];
	CGRect rect;
	[decodedValue getValue:&rect];
	return &rect;
}

 
#pragma mark String

+(NSString *)stringByDecodingXMLEntities:(NSString*) value
{
	if ([Lang isEmptyString:value]) {
		return value;
	}
	 
	
	//@step
	
    NSUInteger myLength = [value length];
    NSUInteger ampIndex = [value rangeOfString:@"&" options:NSLiteralSearch].location;
	
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return value;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
	
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:value];
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
			
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            if (gotNumber) {
                [result appendFormat:@"%C", charCode];
            }
            else {
                NSString *unknownEntity = @"";
                [scanner scanUpToString:@";" intoString:&unknownEntity];
                [result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
            }
            [scanner scanString:@";" intoString:NULL];
        }
        else {
            NSString *unknownEntity = @"";
            [scanner scanUpToString:@";" intoString:&unknownEntity];
            NSString *semicolon = @"";
            [scanner scanString:@";" intoString:&semicolon];
            [result appendFormat:@"%@%@", unknownEntity, semicolon];
            NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
	 NSLog(@"Unsupported XML character entity input [%@]", value);
        }
    }
    while (![scanner isAtEnd]);
	
finish:
    return result;
}


 +(NSString*) toDataAsUTFString:(NSData*) value
{
	//@step   is not binary , format to String 
	NSString *string = 
		 [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding]   ;
	return  string;
}

+(BOOL) isFullNumber:(NSString*) value
{
	bool result = false;
	if ([Lang isEmptyString:value]) {
		return FALSE;
	}
	
	int iSize = [value length];
		 int iCount =0 ;
	 for( int i =0 ;i < iSize; i++)
	 {
		 unichar  item =[value  characterAtIndex: i];
		 if (item == '0' || item =='1' ||
			 item == '2' || item =='3' ||
			 item == '4' || item =='5'||
			 item == '6' || item =='7'||
			  item == '8' || item =='9' 
			 ) 
		 {
			 iCount = iCount + 1;
		 }else {
			 result = FALSE;
			 break;
		 }

	 }
	
	result = iCount == iSize;
		 
   return result;
 
}


+ (id)paseJSONDatatoArrayOrNSDictionary:(NSData *)jsonData{
    
    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                     
                                                    options:NSJSONReadingAllowFragments
                     
                                                      error:&error];
    
    
    
    if (jsonObject != nil && error == nil){
        
        return jsonObject;
        
    }else{
        
       
        
        return nil;
        
    }
    
    
}
 

@end
