//
//  NSURL+Category.m
//  MyProject
//
//  Created by Ethan on 16/8/5.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "NSURL+Category.h"

@implementation NSURL (Category)

- (NSURL *)sandboxIDRefreshedFileURL
{
    if (!self.isFileURL) return nil;
    
    // /var/mobile/Containers/Data/Application/B1C8922B-D4C7-4860-B0DA-146A842EA326/Documents/business/static/9CCE2E2F-BFCC-4723-AE91-BBE6B6F31A53.jpg
    NSArray *components = self.pathComponents;
    __block NSUInteger index = NSNotFound;
    [components enumerateObjectsUsingBlock:^(NSString *component, NSUInteger idx, BOOL *stop) {
        if ([component hasPrefix:@"Application"]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index == NSNotFound || index + 1 >= components.count) return self;
    NSArray *subComponents = [components subarrayWithRange:NSMakeRange(index + 2, components.count - index - 2)];
    NSString *fileSuffix = [subComponents componentsJoinedByString:@"/"];
    NSString *refreshedPath = [NSHomeDirectory() stringByAppendingPathComponent:fileSuffix];
    return [NSURL fileURLWithPath:refreshedPath];
}

@end
