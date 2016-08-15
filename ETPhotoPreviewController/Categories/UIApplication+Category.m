//
//  UIApplication+Category.m
//  MyProject
//
//  Created by Ethan on 16/8/10.
//  Copyright © 2016年 ethan. All rights reserved.
//

#import "UIApplication+Category.h"

@implementation UIApplication (Category)

- (NSString *)bundleID
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
}

- (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (void)autoRegisterRemoteNotifications
{
    if (IS_IOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [self registerUserNotificationSettings:settings];
        [self registerForRemoteNotifications];
    }
    else {
        [self registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
}

@end
