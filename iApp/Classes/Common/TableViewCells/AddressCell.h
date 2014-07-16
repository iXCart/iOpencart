//
//  AddressCell.h
//  iApp
//
//  Created by icoco7 on 7/8/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"

@interface AddressCell : CTableViewCell

@property(nonatomic)IBOutlet UILabel* labelFirst;
@property(nonatomic)IBOutlet UILabel* labelLast;
@property(nonatomic)IBOutlet UIImageView* leftImageView;

@end
