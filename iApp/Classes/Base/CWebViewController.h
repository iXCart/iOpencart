//
//  CWebViewController.h
//  MFPlayer
//
//  Created by icoco7 on 4/30/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewController.h"

@interface CWebViewController : AppViewController <UIWebViewDelegate>
{

@public
    IBOutlet UIWebView * WebContinerView;
}

-(BOOL)loadURLByString:(NSString*)urlString;

@end
