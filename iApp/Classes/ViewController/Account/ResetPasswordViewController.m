//
//  ResetPasswordViewController.m
//  iApp
//
//  Created by icoco7 on 12/12/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "XCartKit.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Utils roundRectView:self.continueButton];
    
    self.title = AppLocalizedString(@"Reset Password");
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




- (IBAction)onSubmit:(id)sender;
{
    [self.emailField resignFirstResponder];
    NSString* email =  self.emailField.text;
    if ([Lang isEmptyString:email]) {
        return;
    }
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    
    
    //@step
    
    //@step
    NSString* urlString = [Resource getResetPasswordURLString] ;
    
    //@step
    [[XCartDataManager sharedInstance] executeAction:urlString method:RKRequestMethodPOST params:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //@step
        
        //@step
        NSDictionary* response = [Lang paseJSONDatatoArrayOrNSDictionary: operation.HTTPRequestOperation.responseData];
        if (nil == response) {
            return  ;
        }
        if ( StringEqual(Rest_success,   [response valueForKey:Rest_status]))
        {
            NSString* message = [response valueForKey:@"data"];
            [CDialogViewManager showMessageView: @"" message:message delayAutoHide:-1];
            [self.navigationController popViewControllerAnimated:true];
        }else
        {
            NSString* message = [response valueForKey:@"data"];

            [CDialogViewManager showMessageView: @"" message:message delayAutoHide:-1];
            
            //[Resource showRestResponseErrorMessage:response];
        }
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSString* buf = operation.HTTPRequestOperation.responseString;
        buf = [Lang trimString:buf];
        
        [CDialogViewManager showMessageView: [Lang trimString:[error localizedDescription]] message:buf delayAutoHide: 3];
        //@step
        
        //@step
    }];

}
@end
