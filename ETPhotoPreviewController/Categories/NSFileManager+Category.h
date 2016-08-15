//
//  NSFileManager+Category.h
//  MyProject
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Category)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url;

@end
