//
//  UIColor+Category.h
//  MyProject
//
//  Created by Ethan on 14-4-3.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/*
 * Creating
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)randomColor;

/*
 * Components
 */
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;
- (NSString *)hexString;

@end
