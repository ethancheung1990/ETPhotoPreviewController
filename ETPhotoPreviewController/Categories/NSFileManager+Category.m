//
//  NSFileManager+Category.m
//  MyProject
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "NSFileManager+Category.h"

@implementation NSFileManager (Category)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url {
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

@end
