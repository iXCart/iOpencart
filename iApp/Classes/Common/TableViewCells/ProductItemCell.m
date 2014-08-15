//
//  ProdcutItemCell.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "ProductItemCell.h"

@implementation ProductItemCell

- (void)awakeFromNib
{
    // Initialization code
 
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArgs:(NSObject*)args
{
    _data = (NSDictionary*)args;
    [self renderView];
}


- (void)renderView
{
     
    self.labelName.text =[_data valueForKey:Cart_Product_name];
    self.labelName.numberOfLines = 2;
    self.labelModel.text = [_data valueForKey:Cart_Product_model];
    self.labelPrice.text =[_data valueForKey:Cart_Product_price];
    
    self.labelStock.text = [_data valueForKey:@"stock"];
    //@step
    NSString* imageUrlString = [_data valueForKey:Product_thumb];
    [Resource assginImageWithSource:self.extImageView source:imageUrlString];

}

/*
-(IBAction)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    self.buttonRemove.hidden = true;
    
}


-(IBAction)swiperLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    self.buttonRemove.hidden = false;
    
}

- (IBAction)remov:(id)sender
{
    //Do what you want here
    //@step
    if (nil != self.observer) {
        [self.observer update:self value:@"delete"];
    }

}
 */
@end
