//
//  CDialogViewManager.m
//  iApp
//
//  Created by icoco7 on 5/29/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CDialogViewManager.h"
#import "CAlertView.h"
@implementation CDialogViewManager

+ ( void)showMessageView:(NSString*)title  message:(NSString*)message delayAutoHide:(NSTimeInterval)delay{

    //@step
   
    NSString* msg = message;
    CAlertView  *alert = [[CAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    
    if (delay<=0) {
        return;
    }
    [alert performSelector:@selector(hide) withObject:nil afterDelay:delay];
    
}
@end
