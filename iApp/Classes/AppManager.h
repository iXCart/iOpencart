//
//  AppManager.h
//  icoco
//
//  Created by icoco on 31/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "Lang.h"

@class CoverViewController;


@interface AppManager : NSObject <ObserverDelegate>{
	 
	UIWindow* _keyWindow;
	UIViewController* _mainViewController;

	UIViewController* _coverViewController ;
	BOOL _isCompletedSetupWorkSpace ;
	 
}


+(AppManager*) sharedInstance;

-(void) startApp;
-(void) terminateApp;
-(void) setupWorkSpace;

-(void) setKeyWindow:(UIWindow*) aWindow;
-(UIView*) getKeyWindow;

 
-(void)setMainViewController:(UIViewController*) aViewController;
-(UIViewController*)getMainViewController;

-(void)showHomeViewInKeyWindow:(int)selectedIndex;

 
-(void)showCoverView;


 
 
//@private


@end
