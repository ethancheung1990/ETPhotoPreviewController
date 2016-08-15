//
//  NSArray+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Category)
//返回index位置的元素
-(id)objectOrNilAtIndex:(NSUInteger)i;
//随机一个元素
-(id)randomObject;
//返回一个元素随机的数组
-(NSArray *)shuffledArray;
//返回一个倒序的数组
-(NSArray *)reverseedArray;
//返回一个无相同元素的数组
-(NSArray *)uniqueArray;
//最快的深copy一个数组
- (NSArray *)fastestAddToArray;

@end
