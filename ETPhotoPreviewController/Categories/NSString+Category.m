//
//  NSString+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSString+Category.h"
#import "NSMutableString+Category.h"
#import "NSData+Category.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MULTILINE_TEXTSIZE(text, font, maxSize, mode) \
({\
[text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;\
});
#else
#define MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

@implementation NSString (Category)
+ (BOOL)CheckUsernameInput:(NSString *)_text
{
    NSString *Regex = @"^\\w{2,16}{1}quot";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+ (BOOL)CheckPhonenumberInput:(NSString *)_text{
    NSString *Regex = @"1\\d{10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+ (BOOL)CheckMailInput:(NSString *)_text{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+ (BOOL)CheckPasswordInput:(NSString *)_text{
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

+ (BOOL)isLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+ (BOOL)isNumbers:(NSString *)_text{
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+ (BOOL)isNumberOrLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

+ (NSString *)stringWithUTF8Data:(NSData *)data{
    return [self stringWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding{
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+ (NSString *)UUID{
    CFUUIDRef UUIDObject = CFUUIDCreate(NULL);
    NSString *UUIDString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, UUIDObject));
    CFRelease(UUIDObject);
    return UUIDString;
}

+ (NSString *)randStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

+ (NSString *)randAlphanumericStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

- (NSURL *)URL{
    return [NSURL URLWithString:self];
}

- (NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, ((CFStringRef)self), NULL, CFSTR("!*'();:@&=+$,/?%#[]<>"), kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));
    return result;
}

- (NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp addQueryDictionary:dictionary];
    return [NSString stringWithString:tmp];
}

- (NSString *)stringByAppendingParameter:(id)parametet forKey:(NSString *)key{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp appendParameter:parametet forKey:key];
    return [NSString stringWithString:tmp];
}

- (CGFloat)widthWithFont:(UIFont *)font
{
    CGSize size;
#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
#else
    size = [self sizeWithFont:font];
#endif
    return size.width;
}

- (BOOL)containsString:(NSString *)string{
    return [self containsString:string ignoringCase:YES];
}

- (BOOL)containsString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    
    NSRange range = [self rangeOfString:string options:options];
    return (range.location != NSNotFound);
}

- (BOOL)equalsToString:(NSString *)string{
    return [self equalsToString:string ignoringCase:YES];
}

- (BOOL)equalsToString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    return (NSOrderedSame == [self compare:string options:options]);
}

- (NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString{
    return [self stringByReplacingString:string withString:newString ignoringCase:NO];
}

- (NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString ignoringCase:(BOOL)ignore{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp replaceString:string withString:newString ignoringCase:ignore];
    return [NSString stringWithString:tmp];
}

- (NSString *)stringByRemovingWhitespace{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespace];
    return [NSString stringWithString:tmp];
}

- (NSString *)stringByRemovingWhitespaceAndNewLine{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespaceAndNewline];
    return [NSString stringWithString:tmp];
}

- (NSString*)stringByRemoveingAllWhitespageAndNewLing {
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespaceAndNewline];
    return [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (NSString*)subStringToBytesLenght:(int)lenght{
    float number = 0.0;
    NSMutableString *resultString = [NSMutableString string];
    for (int index = 0; index < [self length]; index++) {
        
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number+0.5;
        }
        if (number <= lenght) {
            [resultString appendString:character];
        } else {
            break;
        }
    }
    return resultString;
}
- (NSInteger)lengthOfStringBytes
{
    float number = 0.0;
    for (int index = 0; index < [self length]; index++) {
        
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number+0.5;
        }
    }
    return ceil(number);
}

#pragma mark - Hash

- (NSString *)MD5HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}

- (CGSize)sizeWithFont:(UIFont *)font;
{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
}

- (CGSize )sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return MULTILINE_TEXTSIZE(self, font, size, lineBreakMode);
}

+ (NSString*)formateToAtMostTwoDecimalPlacesNum:(CGFloat)num {
    NSInteger l = floor(num*100);
    CGFloat d = l/100.0;
    NSString *des = [@(d) description];
    NSArray *array = [des componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *last = [array lastObject];
        if (last.length > 2) {
            NSString *newLast = [last substringToIndex:2];
            return [NSString stringWithFormat:@"%@.%@", array.firstObject, newLast];
        }
    }
    return des;
}

- (NSString *)sandboxIDRefreshedFilePath
{
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
    return refreshedPath;
}

- (NSString*)sqliteArgString {
    NSMutableString *arg = [NSMutableString stringWithString:self];
    [arg replaceString:@"/" withString:@"//"];
    [arg replaceString:@"'" withString:@"''"];
    [arg replaceString:@"[" withString:@"/["];
    [arg replaceString:@"]" withString:@"/]"];
    [arg replaceString:@"%" withString:@"/%"];
    [arg replaceString:@"&" withString:@"/&"];
    [arg replaceString:@"_" withString:@"/_"];
    [arg replaceString:@"(" withString:@"/("];
    [arg replaceString:@")" withString:@"/)"];
    return [arg copy];
}

@end
