//
//  ServerViewController.m
//  iApp
//
//  Created by icoco7 on 11/21/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()

@end

@implementation ServerViewController

- (void)save:(id)sender {
    
    NSString* url = self.storeUrlTextField.text;
    if ([Lang isEmptyString:url]) {
        return;
    }
    
    AppResourceSet(KeyOfStoreURL, url);
    AppResourceGet(KeyOfStoreURL, DefaultValueOfStoreURL);
    [self closeView:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = AppLocalizedString(@"Store");
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    [self.navigationItem setRightBarButtonItem:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* url = (NSString*)AppResourceGet(KeyOfStoreURL, DefaultValueOfStoreURL);
    self.storeUrlTextField.text = url;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
