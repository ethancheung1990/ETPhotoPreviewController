//
//  UINavigationController+PPCategory.m
//  MyProject
//
//  Created by 王鹏 on 13-3-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "UINavigationController+Category.h"
#import "UINavigationBar+Category.h"
@implementation UINavigationController (Category)
- (id)initWithRootViewController:(UIViewController *)rootViewController navigationBarBackgroundImage:(UIImage *)backgroundImage
{
	self = [self initWithRootViewController:rootViewController];
	if(self)
	{
		[self.navigationBar setBackgroundImage:[backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
	}
	return self;
}

@end
