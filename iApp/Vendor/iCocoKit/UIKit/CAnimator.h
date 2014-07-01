//
//  CAnimator.h
//  iApp
//
//  Created by icoco7 on 6/10/14.
//  Copyright (c) 2014 icoco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAnimator : NSObject


+ (void)fadeView:(UIView*)targetView completion:(void (^)(BOOL finished))completion;

@end
