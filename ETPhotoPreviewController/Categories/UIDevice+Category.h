//
//  UIDevice+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Category)
//判断设备型号
-(NSString *)platform;
-(NSString *)platformString;
//判断设备是否能拨号
-(BOOL)hasMicrophone;
-(BOOL)isThreePointFiveInchDevice;

@end
