//
//  CartConfirmItemCell.m
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import "CartConfirmItemCell.h"

@implementation CartConfirmItemCell

- (void)awakeFromNib
{
    // Initialization code
    self.stepper.maximumValue = INT16_MAX;
    self.stepper.minimumValue =1;
    self.stepper.stepValue = 1;
    self.stepper.value = 0;
    self.stepper.autorepeat = false;
    self.stepper.continuous = false;
   
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
    NSNumber* value =  [_data valueForKey: Product_quantity];
    NSInteger quantity = [value intValue];
    self.stepper.continuous = false;
     
    self.stepper.value = quantity;
    NSLog(@"%@->renderView->stepper:%d, quantity=%d", self, (int)self.stepper.value, (int)quantity);
    
    self.labelName.text =[_data valueForKey:Cart_Product_name];
    self.labelName.numberOfLines = 2;
    self.labelModel.text = [_data valueForKey:Cart_Product_model];
    self.labelPrice.text =[_data valueForKey:Cart_Product_price];
    
    self.labelQuantity.text = [Lang safeNumberToIntString:[_data valueForKey:Cart_Product_quantity] toValue:@""] ;
    self.labelTotal.text = [_data valueForKey:Cart_Product_total];
    //@step
    NSString* imageUrlString = [_data valueForKey:Product_thumb];
    [Resource assginImageWithSource:self.extImageView source:imageUrlString];

}

- (void)keepOrignalValue:(NSDictionary*) data
{
    NSNumber* orignalValue = [data valueForKey:Product_quantity_orignal];
    if (nil == orignalValue) {
        orignalValue = [data valueForKey:Product_quantity];
        [_data setValue:orignalValue forKey:Product_quantity_orignal];
    }
}

-  (IBAction)onValueChanged:(id)sender
{
    NSLog(@"%@->onValueChanged", sender);
    
    UIStepper* stepper = (UIStepper*)sender;
    int quantity = stepper.value;
    
    //@step updateModel
    //@step set the status value
    [self keepOrignalValue:_data];
    
    NSNumber* number = [NSNumber numberWithInteger:quantity];
    [_data setValue:number forKey:Product_quantity];
 
    
    //@step
    float price = [Lang safeStringToFloat:[_data valueForKey:Cart_Product_price]  toValue:0] ;
    float total = price * quantity;
    NSString* totalString = [NSString stringWithFormat:@"$%.2f", total];
    [_data setValue:totalString forKey:Cart_Product_total];
    
    //@step
    self.labelQuantity.text = [Lang safeNumberToIntString:[_data valueForKey:Cart_Product_quantity] toValue:@""] ;
    self.labelTotal.text = [_data valueForKey:Cart_Product_total];
    //@step
    if (nil != self.observer) {
        [self.observer update:self value:sender];
    }
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
