//
//  AppManager.m
//   icoco
//
//  Created by icoco on 31/07/2008.
//  Copyright 2008 icoco. All rights reserved.
//
#import "AppManager.h"
#import "Util.h"
#import "Resource.h"
#import "CoverViewController.h"
#import "LoginViewController.h"
#import "CNavigationController.h"

#import "DataModel.h"

static AppManager *  _appManagerInstance = nil;

@implementation AppManager



+(AppManager*) sharedInstance
{
    @synchronized(self) {
        if ( nil == _appManagerInstance)
        {
            _appManagerInstance =  [[AppManager alloc ] init] ;
        }
    }
	return _appManagerInstance;
}



+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (_appManagerInstance == nil) {
            _appManagerInstance = [super allocWithZone:zone];
            return _appManagerInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
/*
 - (id)retain {
 return self;
 }
 
 - (unsigned)retainCount {
 return UINT_MAX;  // denotes an object that cannot be released
 }
 
 - (oneway void)release {
 //do nothing
 //[super release];
 }
 
 - (id)autorelease {
 return self;
 }
 
 
 
 - (void)dealloc
 {
 AppTrace(self, @"dealloc");
 
 [mSyncTimer release];
 
 
 [coverViewController release];
 
 [super dealloc];
 }
 */

-(void) startApp;
{
}

-(void) terminateApp
{
}

-(NSArray*) loadTabViewControllers
{
    NSString* cfgFilePath =[Utils getBundleFileAsFullPath:  @"tabDefs.plist"];
    
	NSArray* items = [CUIEnginer getTabViewControllersWithCfg:cfgFilePath];
    
    NSLog(@"getTabViewControllers:[%@]", items);
    return  items;
    
}

-(void) setKeyWindow:(UIWindow*) aWindow
{
	_keyWindow = aWindow;
}
-(UIView*) getKeyWindow
{
	return _keyWindow;
}

-(void)setMainViewController:(UIViewController*) aViewController
{
	_mainViewController = aViewController;
}

-(UIViewController*)getMainViewController
{
	return _mainViewController;
}

- (UITabBarController*)getMainTabBarController
{
    return (UITabBarController*)_mainViewController;
}

-(void)update:(id)sender  value :(id) value
{
    
}

-(void)showCoverView 
{
	//@step
	if (nil == _coverViewController) {
		_coverViewController = [CUIEnginer createViewController:@"CoverViewController" inNavigationController:false];
        
	}
    _keyWindow.rootViewController = _coverViewController;
    [_keyWindow makeKeyAndVisible];
}

-(void)replaceCoverView:(UIViewController*)new
{
        //@step
    UIView* coverView = _coverViewController.view;
    
     [CAnimator fadeView:coverView
              completion:^(BOOL finished) {
                  
                  _keyWindow.rootViewController = new;
                  //[keyWindow makeKeyAndVisible];

              }];
    
	 
    
}


- (void) showTabControllerView
{
    //@step
	NSArray* tabs =  [ [AppManager sharedInstance] loadTabViewControllers];
    UITabBarController* tabBarController = (UITabBarController*)[self getMainViewController];
    tabBarController.viewControllers = tabs;
    
   [self replaceCoverView:tabBarController];
	
}


-(void)onCompletedSetupWorkSpace
{
    NSLog(@"onCompletedSetupWorkSpace");


    [self showTabControllerView];
    
	_isCompletedSetupWorkSpace = TRUE;
    
}

-(BOOL) isCompletedSetupWorkSpace
{
	return _isCompletedSetupWorkSpace;
}


#pragma mark setupWorkSpace
-(void) setupWorkSpace
{
    //@step do init work
    
    //@step
    [self performSelector:@selector(onCompletedSetupWorkSpace) withObject:nil afterDelay:8];
    return;
    
    [self  onCompletedSetupWorkSpace];
 	
}


- (void)showHomeViewInKeyWindow:(int)selectedIndex
{
    [self getMainTabBarController].selectedIndex =  selectedIndex ;
}

//
//-(void) registerListener {
//
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onComplete: )
// 												 name:(NSString*)_KeyNotifyOnCompleteLoadSystemText object:nil];
//
//
//}
//-(void) unRegisterListener{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString*)_KeyNotifyOnCompleteLoadSystemText object:nil];
//
//}


@end
