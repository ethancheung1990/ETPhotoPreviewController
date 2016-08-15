//
//  NSInvocation+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (Category)
//传递多个参数的方法
+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector andArguments:(NSArray *)arguments;
@end
