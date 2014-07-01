//
//  CWebViewController.m
//  MFPlayer
//
//  Created by icoco7 on 4/30/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import "CWebViewController.h"

@interface CWebViewController ()

@end

@implementation CWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender NS_AVAILABLE_IOS(5_0);
{
    NSLog(@"[%@]->prepareForSegue",self);
    if ( WebContinerView.isLoading)
    {
         [WebContinerView stopLoading];
          WebContinerView.delegate =nil ;
         
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma Web action
-(BOOL)loadURLByString:(NSString*)urlString
{
    NSLog(@"load->%@",urlString);
    NSURL* url = [NSURL URLWithString:urlString];
    if (nil ==url) {
        return FALSE ;
    }
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [WebContinerView loadRequest:req];
    return TRUE;
}
#pragma Web delgate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"[%@]->webViewDidStartLoad",self);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   NSLog(@"[%@]->webViewDidFinishLoad",self);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    NSLog(@"[%@]->didFailLoadWithError->[%@]",self, error);
}

@end
