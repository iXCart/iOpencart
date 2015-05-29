//
//  AppViewController.h
//  MFPlayer
//
//  Created by icoco7 on 4/30/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppViewController : UIViewController
{
}

@property(nonatomic,strong)NSDictionary* args;

+ (AppViewController*)create;

- (void) closeView:(id)sender;

- (IBAction)unwindSegueRouteView:(UIStoryboardSegue *)segue ;

@end
