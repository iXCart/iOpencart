//
//  ImagePagesViewCell.m
//  iApp
//
//  Created by icoco7 on 6/22/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ImagePagesViewCell.h"
#import "CPageContainerViewController.h"

@implementation ImagePagesViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setPages:(NSArray*)defs
{
    if ( nil == _pageContainer) {
        CPageContainerViewController* container = (CPageContainerViewController*)[CUIEnginer createViewController:@"CPageContainerViewController" inNavigationController:false];
        
        _pageContainer = container;
        
        _pageContainer.view.frame = self.contentView.frame;
        
        [ self.contentView addSubview:_pageContainer.view];
    }
    
    
    _pageContainer.contentList = defs;
     
    [_pageContainer preparePages];
}

#pragma mark setup
//@override
- (void)setArgs:(NSObject*)args{
    [super setArgs:args];
    
    if (nil == args || ![args isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary* dict = (NSDictionary*)args;
    NSArray* images = [Resource getImagesDefsFromProductResult:dict];
    if (nil != images) {
         [self setPages:images];
    }
    

    NSLog(@"%@->setup:%@", self,images);
   
}
@end
