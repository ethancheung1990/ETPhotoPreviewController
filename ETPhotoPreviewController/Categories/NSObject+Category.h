//
//  NSObject+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)
//输出类名
- (NSString *)classString;

//创建关联
- (void)associateValue:(id)value withKey:(void *)key;
- (void)weakAssoicateVaule:(id)value withKey:(void *)key;
//取得关联对象
- (id)accociatedVauleForKey:(void *)key;


- (BOOL)isVauleForKeyPath:(NSString *)keyPath equalToVaule:(id)value;
- (BOOL)isVauleForKeyPath:(NSString *)keyPath identicalToVaule:(id)value;
+ (NSDictionary *)propertyAttributes;

//在dealloc的时候输出类名，用来判断内存泄漏。
- (void)logOnDealloc;


@end
