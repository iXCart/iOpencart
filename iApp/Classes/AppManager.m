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
    [self registerListener];
    
    [[DataModel sharedInstance] auotoLogin];
    
    //@step
    [self performSelector:@selector(onCompletedSetupWorkSpace) withObject:nil afterDelay:2];
    return;
    
    [self  onCompletedSetupWorkSpace];
 	
}


- (void)showHomeViewInKeyWindow:(int)selectedIndex
{
    [self getMainTabBarController].selectedIndex =  selectedIndex ;
}

- (void)upateShoppingCartBar:(NSDictionary*)dict
{
    
    UITabBarController* tab = [self getMainTabBarController];
    UITabBarItem* cartItem = [tab.tabBar.items objectAtIndex:1];
    
    NSString* count = [dict valueForKey:@"count"];
    if ([Lang isEmptyString:count]) {
        count = nil;
    }
    cartItem.badgeValue = count;
    
}

- (void)onNotifyEventCommpleteAddCart:(NSNotification*)notifycation
{
    NSDictionary* dict =[notifycation object];
    
    [self upateShoppingCartBar:dict];
}

-(void) registerListener {

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyEventCommpleteAddCart: )
 												 name: NotifyEventCommpleteAddCart object:nil];


}
-(void) unRegisterListener{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NotifyEventCommpleteAddCart object:nil];

}


@end
