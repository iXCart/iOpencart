//
//  CTableViewCell.h
//  iApp
//
//  Created by icoco7 on 6/22/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTableViewCell : UITableViewCell
{
    NSObject* _args ;
}
@property(nonatomic)NSIndexPath* indexPath;

- (void)setArgs:(NSObject*)args;
- (NSObject*)getArgs;

@end
