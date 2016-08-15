//
//  NSMutableAttributedString+Category.h
//  MyProject
//
//  Created by Nemo on 14-4-11.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Category)

+ (NSMutableAttributedString *)creatMutableAttributedString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color;
/*
 *若重复使用此方法，不会覆盖之前的设置
 */
- (void)addKeyColor:(UIColor *)keyColor keyString:(NSString *)keyString;
@end
