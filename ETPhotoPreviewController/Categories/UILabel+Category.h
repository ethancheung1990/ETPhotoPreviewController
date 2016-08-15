//
//  UILabel+Category.h
//  MyProject
//
//  Created by Nemo on 14-4-4.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 *calculate the needed size of lable's AttributedString
 **/

- (CGFloat)heightForLableAttributedStringConstrainedToSize:(CGSize )maxSize;

- (void)sizeToFitWithSize:(CGSize)size;


@end
