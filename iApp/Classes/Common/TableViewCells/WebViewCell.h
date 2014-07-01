//
//  WebViewCell.h
//  iApp
//
//  Created by icoco7 on 6/22/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"

@interface WebViewCell : CTableViewCell<UIWebViewDelegate>

@property(nonatomic)IBOutlet UIWebView* webView;

@end
