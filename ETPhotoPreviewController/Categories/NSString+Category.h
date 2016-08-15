//
//  NSString+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
//判断用户名是否是2～16位；
+(BOOL)CheckUsernameInput:(NSString *)_text;
//判断手机号码，1开头的十一位数字
+(BOOL)CheckPhonenumberInput:(NSString *)_text;
//判断邮箱
+(BOOL)CheckMailInput:(NSString *)_text;
//判断密码，6－16位
+(BOOL)CheckPasswordInput:(NSString *)_text;
//判断是否字母构成
+ (BOOL)isLetters:(NSString *)_text;
//判断是否是数字构成
+ (BOOL)isNumbers:(NSString *)_text;
//判断是否是数字或字母构成
+ (BOOL)isNumberOrLetters:(NSString *)_text;
+(BOOL)isValidateEmail:(NSString *)email;
//创建字符串
+ (NSString *)stringWithUTF8Data:(NSData *)data;
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

//生成唯一id
+ (NSString *)UUID;
//生成一个固定长度的随即字符串
+ (NSString *)randStringWithLength:(NSUInteger)length;
//生成一个固定长度不带数字的字符串
+ (NSString *)randAlphanumericStringWithLength:(NSUInteger)length;
//直接将string改为string
- (NSURL *)URL;
//将string编码
- (NSString *)URLEncodedString;
//将sring解码
- (NSString *)URLDecodedString;
//返回一个string包含一个dictionary中的所有条目
-(NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary;
//
-(NSString *)stringByAppendingParameter:(id)parametet forKey:(NSString *)key;
//返回string的宽度
- (CGFloat)widthWithFont:(UIFont *)font;
//判断是否存在子字符串
-(BOOL)containsString:(NSString *)string;
-(BOOL)containsString:(NSString *)string ignoringCase:(BOOL)ignore;
//判断是否和字符串相等
-(BOOL)equalsToString:(NSString *)string;
-(BOOL)equalsToString:(NSString *)string ignoringCase:(BOOL)ignore;
//替换掉字符串中的子字符串
-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString;
-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString ignoringCase:(BOOL)ignore;
//删除空格
-(NSString *)stringByRemovingWhitespace;
//删除空格和换行
-(NSString *)stringByRemovingWhitespaceAndNewLine;

//删除所有空格和换行
- (NSString*)stringByRemoveingAllWhitespageAndNewLing;

//返回给定长度的子字符串 （绝大部分非英汉字用UTF-8编码占用三个字节）算一个长度，不是汉字算半个长度
- (NSString*)subStringToBytesLenght:(int)lenght;
//返回指定字符串的长度 （绝大部分非英文汉字用UTF-8编码占用三个字节）算一个长度，不是汉字算半个长度
-(NSInteger)lengthOfStringBytes;

///-------------------------------
/// Hash
///-------------------------------
- (NSString *)MD5HashString;
- (NSString *)SHA1HashString;

- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (NSString*)formateToAtMostTwoDecimalPlacesNum:(CGFloat)num;

@end
