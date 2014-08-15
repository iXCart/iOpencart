//
//  OrderCell.h
//  iApp
//
//  Created by icoco7 on 8/13/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"

@interface OrderCell : CTableViewCell

@property(nonatomic)IBOutlet UILabel* labelOrderID;
@property(nonatomic)IBOutlet UILabel* labelStatus;
@property(nonatomic)IBOutlet UILabel* labelProducts;
@property(nonatomic)IBOutlet UILabel* labelTotal;

@end
