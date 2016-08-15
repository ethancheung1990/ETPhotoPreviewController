//
//  NSMutableDictionary+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSMutableDictionary+Category.h"

@implementation NSMutableDictionary (Category)
-(void)setObject:(id)object forKeyIfNotNil:(id)key{
    if (object && key) {
        [self setObject:object forKey:key];
    }
}
@end
