//
//  CUIEnginer.h
//  iApp
//
//  Created by icoco7 on 6/24/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUIEnginer : NSObject


+(UIViewController*)createViewController:(NSString*) className inNavigationController :(BOOL) inNavigationController;

+(UIViewController*) viewController4Tab:(NSDictionary*)data;
+(NSArray*) getTabViewControllersWithCfg:(NSString*)cfgFilePath;

@end
