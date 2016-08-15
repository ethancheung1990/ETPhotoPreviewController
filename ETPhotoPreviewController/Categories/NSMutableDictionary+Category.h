//
//  NSMutableDictionary+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Category)
//将一个元素加入dictionary
-(void)setObject:(id)object forKeyIfNotNil:(id)key;
@end
