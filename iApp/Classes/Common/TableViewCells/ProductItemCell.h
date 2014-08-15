//
//  ProdcutItemCell.h
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"

@interface ProductItemCell : CTableViewCell
{
    NSDictionary* _data;
}
@property(nonatomic)IBOutlet UIImageView* extImageView;

@property(nonatomic)IBOutlet UILabel* labelName;
@property(nonatomic)IBOutlet UILabel* labelModel;
@property(nonatomic)IBOutlet UILabel* labelPrice;
@property(nonatomic)IBOutlet UILabel* labelStock;
 

@property(nonatomic) id <ObserverDelegate>observer;

@end
