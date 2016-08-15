//
//  UINavigationBar+PPCategory.m
//  MyProject
//
//  Created by 王鹏 on 13-3-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "UINavigationBar+Category.h"
#import <QuartzCore/QuartzCore.h>
@implementation UINavigationBar (Category)
- (void)setBackgroundImage:(UIImage *)backgroundImage
{

    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
	
	[self setNeedsDisplay];
}
@end
