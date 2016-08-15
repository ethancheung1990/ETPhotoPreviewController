//
//  Macro.h
//  MyProject
//
//  Created by Ethan on 16/8/8.
//  Copyright © 2016年 ethan. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define IS_IOS7 (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
#define IS_IOS8 (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0)
#define IS_IOS9 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_4)
#define MainScreenWidth  [[UIScreen mainScreen] bounds].size.width

#endif /* Macro_h */
