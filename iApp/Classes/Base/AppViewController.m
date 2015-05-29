//
//  AppViewController.m
//  MFPlayer
//
//  Created by icoco7 on 4/30/14.
//  Copyright (c) 2014 icocosoftware. All rights reserved.
//

#import "AppViewController.h"


@interface AppViewController ()

@end

@implementation AppViewController

+(AppViewController*)create
{
    
    NSString* className = NSStringFromClass( [self class]);
    return (AppViewController*)[CUIEnginer createViewController:className inNavigationController:false];
}


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
    NSLog(@"viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any Resource that can be recreated.
}

-(void)dealloc
{
    NSLog(@"%@->dealloc", self);
    
}

- (void) closeView:(id)sender;
{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    UIViewController* parent = self.parentViewController;
    if (nil != parent && [parent isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nv = (UINavigationController*) parent;
        [nv popViewControllerAnimated:true];
    }
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

-(IBAction)unwindSegueRouteView:(UIStoryboardSegue *)segue {
    
    NSLog(@"%@->%@:id->[%@] source->:[%@] destination->[%@]",self, segue,
          segue.identifier,
          segue.sourceViewController,
          segue.destinationViewController);
    
}


-(void) registerListener {

}
-(void) unRegisterListener{
}

@end
