//
//  NSTimeZone+Category.m
//  MyProject
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "NSTimeZone+Category.h"

@implementation NSTimeZone (Category)

+ (NSTimeZone*)beijingTimeZone {
    return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
}

@end
