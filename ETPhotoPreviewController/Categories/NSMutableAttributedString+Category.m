//
//  NSMutableAttributedString+Category.m
//  MyProject
//
//  Created by Nemo on 14-4-11.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSMutableAttributedString+Category.h"
#import <CoreText/CoreText.h>



@implementation NSMutableAttributedString (Category)

+ (NSMutableAttributedString *)creatMutableAttributedString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color
{
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:color,
                              NSFontAttributeName:font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:attribs];
    
    return attributedText;
}
- (void)addKeyColor:(UIColor *)keyColor keyString:(NSString *)keyString
{
    NSString *fullStr = [self string];
    NSRange textRange = [fullStr rangeOfString:keyString];
    [self addAttribute:(__bridge NSString *)kCTForegroundColorAttributeName value:keyColor range:textRange];
}
@end
