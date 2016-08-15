//
//  NSMutableArray+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSMutableArray+Category.h"

@implementation NSMutableArray (Category)
-(id)addObjectIfNotNil:(id)object{
    if (object) {
        [self addObject:object];
        return object;
    }
    return nil;
}

-(id)addNonEqualObjectIfNotNil:(id)object{
    if (object) {
        if ([self indexOfObject:object] == NSNotFound) {
            [self addObject:object];
            return object;
        }
    }
    return nil;
}


-(id)addNonIdenticalObjectIfNotNil:(id)object{
    if (object) {
        if ([self indexOfObjectIdenticalTo:object] == NSNotFound) {
            [self addObject:object];
            return object;
        }
    }
    return nil;
}

-(id)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index{
    if (object && index <= [self count]) {
        [self insertObject:object atIndex:index];
        return object;
    }
    return nil;
}

-(id)moveObjectAthIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex{
    if (index == toIndex) {
        return nil;
    }
    
    if (index < [self count] && toIndex < [self count]) {
        id object =[self objectAtIndex:index];
        [self removeObjectAtIndex:index];
        [self insertObject:object atIndex:toIndex];
        return object;
    }
    
    return nil;
}

-(void)removeFirstObject{
    if ([self count] > 0) {
        [self removeObjectAtIndex:0];
    }
}


-(void)shuffle{
    for (NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger m = 1;
        do {
            m <<= 1;
        } while (m < i);
        
        NSUInteger j;
        do {
            j = arc4random() % m;
        } while (j >= i);
        
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

-(void)reverse{
    for (int i = 0; i < (floor([self count] / 2.0)); i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count] - (i+1))];
    }
}

-(void)unique{
    NSArray *tmp = [self copy];
    [self removeAllObjects];
    for (id object in tmp) {
        [self addNonEqualObjectIfNotNil:object];
    }
}

-(id)push:(id)object{
    return [self addNonEqualObjectIfNotNil:object];
}

-(id)pop{
    if ([self count] > 0) {
        id object = [self lastObject];
        [self removeLastObject];
        return object;
    }
    return nil;
}

-(id)enqueue:(id)object{
    if (object) {
        [self insertObject:object atIndex:0];
        return object;
    }
    return nil;
}

-(id)dequeue{
    if ([self count] > 0) {
        id object =[self lastObject];
        [self removeLastObject];
        return object;
    }
    return nil;
}

- (void)replaceObjectOrNilAtIndex:(NSUInteger)idx withObject:(id)object
{
    if (self.count > idx && object) {
        [self replaceObjectAtIndex:idx withObject:object];
    }
}


@end
