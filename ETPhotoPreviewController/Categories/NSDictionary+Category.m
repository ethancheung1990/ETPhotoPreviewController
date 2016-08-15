//
//  NSDictionary+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSDictionary+Category.h"
#import "NSString+Category.h"

@implementation NSDictionary (Category)
-(BOOL)hasObjectForkey:(id)key{
    return [[self allKeys] containsObject:key];
}

-(NSString *)queryString{
    NSMutableArray *parameters = [NSMutableArray array];
    
    NSEnumerator *enumerator = [self keyEnumerator];
    NSString *key = nil;
    while ((key = [enumerator nextObject])) {
        NSString *parameter = [self objectForKey:key];
        [parameters addObject:[NSString stringWithFormat:@"%@=%@",[key URLEncodedString],[parameter URLEncodedString]]];
    }
    
    return [parameters componentsJoinedByString:@"&"];
}


- (id)objectOrNilForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else
    {
        return object;
    }
}


- (NSDictionary *)fastestAddToDictionary
{
    NSSet *matchingKeys = [self keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id key, id obj, BOOL *stop) {
        return YES;
    }];
    NSArray *keys = matchingKeys.allObjects;
    NSArray *values = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    NSDictionary *filteredDictionary = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    return filteredDictionary;
}

@end
