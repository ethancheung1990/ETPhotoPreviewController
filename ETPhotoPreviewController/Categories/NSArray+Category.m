//
//  NSArray+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSArray+Category.h"
#import "NSMutableArray+Category.h"

@implementation NSArray (Category)

-(id)objectOrNilAtIndex:(NSUInteger)i{
    if (i < [self count]) {
        return [self objectAtIndex:i];
    }
    return nil;
}

-(id)randomObject{
    if ([self count] > 0) {
        int i = arc4random() % [self count];
        return [self objectAtIndex:i];
    }
    return nil;
}

-(NSArray *)shuffledArray{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self];
    [tmp shuffle];
    return [NSArray arrayWithArray:tmp];
}

-(NSArray *)reverseedArray{
    NSMutableArray *tmp =[NSMutableArray arrayWithArray:self];
    [tmp reverse];
    return [NSArray arrayWithArray:tmp];
}

-(NSArray *)uniqueArray{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self];
    [tmp unique];
    return [NSArray arrayWithArray:tmp];
}

- (NSArray *)fastestAddToArray
{
    NSIndexSet *indexes = [self indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return YES;
    }];
    NSArray *filteredArray = [self objectsAtIndexes:indexes];
    return filteredArray;
}

@end
