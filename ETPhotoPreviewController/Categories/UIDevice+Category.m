//
//  UIDevice+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "UIDevice+Category.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Category)
-(NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

-(NSString *)platformString{
    NSString *platform = [self platform];
    if ( [platform isEqualToString:@"iPhone1,1"] ) return @"iPhone 2G";
    if ( [platform isEqualToString:@"iPhone1,2"] ) return @"iPhone 3G";
    if ( [platform isEqualToString:@"iPhone2,1"] ) return @"iPhone 3GS";
    if ( [platform isEqualToString:@"iPhone3,1"] ) return @"iPhone 4";
    if ( [platform isEqualToString:@"iPhone3,2"] ) return @"iPhone 4";
    if ( [platform isEqualToString:@"iPhone3,3"] ) return @"iPhone 4";
    if ( [platform isEqualToString:@"iPhone4,1"] ) return @"iPhone 4S";
    if ( [platform isEqualToString:@"iPhone5,1"] ) return @"iPhone 5";
    if ( [platform isEqualToString:@"iPhone5,2"] ) return @"iPhone 5";
    if ( [platform isEqualToString:@"iPhone5,3"] ) return @"iPhone 5C";
    if ( [platform isEqualToString:@"iPhone5,4"] ) return @"iPhone 5C";
    if ( [platform isEqualToString:@"iPhone6,1"] ) return @"iPhone 5S";
    if ( [platform isEqualToString:@"iPhone6,2"] ) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ( [platform isEqualToString:@"iPod1,1"] ) return @"iPod touch 1G";
    if ( [platform isEqualToString:@"iPod2,1"] ) return @"iPod touch 2G";
    if ( [platform isEqualToString:@"iPod3,1"] ) return @"iPod touch 3G";
    if ( [platform isEqualToString:@"iPod4,1"] ) return @"iPod touch 4G";
    if ( [platform isEqualToString:@"iPod5,1"] ) return @"iPod touch 5G";
    
    if ( [platform isEqualToString:@"iPad1,1"] ) return @"iPad 1G";
    if ( [platform isEqualToString:@"iPad2,1"] ) return @"iPad 2";
    if ( [platform isEqualToString:@"iPad2,2"] ) return @"iPad 2";
    if ( [platform isEqualToString:@"iPad2,3"] ) return @"iPad 2";
    if ( [platform isEqualToString:@"iPad2,4"] ) return @"iPad 2";
    if ( [platform isEqualToString:@"iPad2,5"] ) return @"iPad mini 1G";
    if ( [platform isEqualToString:@"iPad2,6"] ) return @"iPad mini 1G";
    if ( [platform isEqualToString:@"iPad2,7"] ) return @"iPad mini 1G";
    if ( [platform isEqualToString:@"iPad3,1"] ) return @"iPad 3";
    if ( [platform isEqualToString:@"iPad3,2"] ) return @"iPad 3";
    if ( [platform isEqualToString:@"iPad3,3"] ) return @"iPad 3";
    if ( [platform isEqualToString:@"iPad3,4"] ) return @"iPad 4";
    if ( [platform isEqualToString:@"iPad3,5"] ) return @"iPad 4";
    if ( [platform isEqualToString:@"iPad3,6"] ) return @"iPad 4";
    if ( [platform isEqualToString:@"iPad4,1"] ) return @"iPad Air";
    if ( [platform isEqualToString:@"iPad4,2"] ) return @"iPad Air";
    if ( [platform isEqualToString:@"iPad4,4"] ) return @"iPad mini 2G";
    if ( [platform isEqualToString:@"iPad4,5"] ) return @"iPad mini 2G";
    if ( [platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    
    return @"Unknown iOS Device";
}

-(BOOL)hasMicrophone{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return YES;
	if ([platform isEqualToString:@"iPhone1,2"]) return YES;
	if ([platform isEqualToString:@"iPhone2,1"]) return YES;
	if ([platform isEqualToString:@"iPhone3,1"]) return YES;
    if ([platform isEqualToString:@"iPhone4,1"]) return YES;
	if ([platform isEqualToString:@"iPhone5,1"]) return YES;
    if ( [platform isEqualToString:@"iPhone5,2"] ) return YES;
    if ( [platform isEqualToString:@"iPhone5,3"] ) return YES;
    if ( [platform isEqualToString:@"iPhone5,4"] ) return YES;
    if ( [platform isEqualToString:@"iPhone6,1"] ) return YES;
    if ( [platform isEqualToString:@"iPhone6,2"] ) return YES;
    
    return NO;
}

-(BOOL)isThreePointFiveInchDevice
{
    return [UIScreen mainScreen].bounds.size.height == 480.0;
}

@end
