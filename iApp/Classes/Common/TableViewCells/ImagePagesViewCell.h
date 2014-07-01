//
//  ImagePagesViewCell.h
//  iApp
//
//  Created by icoco7 on 6/22/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTableViewCell.h"
#import "CPageContainerViewController.h"

@interface ImagePagesViewCell : CTableViewCell{
    
    CPageContainerViewController* _pageContainer;

}

- (void)setPages:(NSArray*)defs;

@end
