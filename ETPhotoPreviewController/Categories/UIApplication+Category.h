//
//  UIApplication+Category.h
//  MyProject
//
//  Created by Ethan on 16/8/10.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Category)

- (NSString *)bundleID;

- (NSString *)appVersion;

- (void)autoRegisterRemoteNotifications;

@end
