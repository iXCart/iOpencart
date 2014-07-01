//
//  CDialogViewManager.h
//  iApp
//
//  Created by icoco7 on 5/29/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDialogViewManager : NSObject


+ ( void)showMessageView:(NSString*)title  message:(NSString*)message delayAutoHide:(NSTimeInterval)delay;

@end
