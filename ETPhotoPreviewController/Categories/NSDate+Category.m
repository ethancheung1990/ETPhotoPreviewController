//
//  NSDate+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSDate+Category.h"

static NSTimeInterval __systemUptime__ = 0;
static NSDate *__standardTime__ = nil;

@implementation NSDate (Category)

+ (void)setStandardTime:(NSDate *)standardTime {
    if (!standardTime) {
        return;
    }
    __systemUptime__ = [[NSProcessInfo processInfo] systemUptime];
    __standardTime__ = standardTime;
}

+ (NSDate *)fixedDate {
    if (__standardTime__) {
        NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime] - __systemUptime__;
        return [NSDate dateWithTimeInterval:time sinceDate:__standardTime__];
    }
    return [NSDate date];
}

- (NSDateComponents *)dateComponents {
    NSCalendarUnit calendarUnit =
    NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekCalendarUnit |
    NSWeekdayCalendarUnit |
    NSWeekdayOrdinalCalendarUnit |
    NSQuarterCalendarUnit |
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    NSWeekOfMonthCalendarUnit |
    NSWeekOfYearCalendarUnit |
    NSYearForWeekOfYearCalendarUnit |
#endif
    NSCalendarCalendarUnit |
    NSTimeZoneCalendarUnit;
    return [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
}

#pragma mark - compare

-(BOOL)isEarlizerThanDate:(NSDate *)dt {
    return ([self earlierDate:dt] == self);
}

-(BOOL)isLaterThanDate:(NSDate *)dt {
    return ([self laterDate:dt] == self);
}

-(BOOL)isSameYearAsDate:(NSDate *)dt {
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return ([components1 year] == [components2 year]);
}

-(BOOL)isSameMonthAsDate:(NSDate *)dt {
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month]));
}

-(BOOL)isSameWeekAsDate:(NSDate *)dt {
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 weekOfYear] == [components2 weekOfYear]));
}

-(BOOL)isSameDayAsDate:(NSDate *)dt {
    NSDateComponents *components1 = [self dateComponents];
    NSDateComponents *components2 = [dt dateComponents];
    return (([components1 year] == [components2 year]) &&
            ([components1 month] == [components2 month] )&&
            ([components1 day] == [components2 day]));
}

#pragma mark - format

- (NSString *)toISO8601 {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toYYYYMMdd {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:self];
}

- (NSString *)toYYYYMMDDhhmmss {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyyMMddHHmmss"];
	return [formatter stringFromDate:self];
}

- (NSString *)toYYYY_MM_DD_hh_mm_ss {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	return [formatter stringFromDate:self];
}

- (NSString *)tohh_mm {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:self];
}

- (NSString *)toYYYY_MM_DD {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	return [formatter stringFromDate:self];
}

- (NSString *)toYYYYMM {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMM"];
    return [formatter stringFromDate:self];
}

- (NSString *)toYYYY_MM {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:self];
}

- (NSString *)toMM_DD {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"MM-dd"];
	return [formatter stringFromDate:self];
}

- (NSString*)toMM_DD_HH_mm {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM-dd HH:mm"];
    return [f stringFromDate:self];
}

- (NSString*)toMM_DD_HH_mm_OR_yyyy_MM_DD_HH_mm {

    NSDate *currentDate = [NSDate fixedDate];

    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    if ([self isSameYearAsDate:currentDate]) {
        [f setDateFormat:@"MM-dd HH:mm"];
    } else {
        [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return [f stringFromDate:self];
}

- (NSString*)toyyyy_MM_DD_HH_mm {

    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [f stringFromDate:self];
}

- (NSString*)toMM_DD_OR_yyyy_MM_DD {

    NSDate *currentDate = [NSDate fixedDate];

    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    if ([self isSameYearAsDate:currentDate]) {
        [f setDateFormat:@"MM-dd"];
    } else {
        [f setDateFormat:@"yyyy-MM-dd"];
    }
    return [f stringFromDate:self];
}

- (NSString*)relativeTimeString {
    
    NSDate *currentDate = [NSDate fixedDate];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    NSString *prefix = nil;
    if ([self isSameDayAsDate:currentDate]) {
        [f setDateFormat:@"HH:mm"];
        prefix = @"今天 ";
    } else if ([self isSameDayAsDate:currentDate.yesterdayBeginTime]) {
        [f setDateFormat:@"HH:mm"];
        prefix = @"昨天 ";
    } else if ([self isSameYearAsDate:currentDate]) {
        [f setDateFormat:@"MM月dd日"];
        prefix = @"";
    } else {
        [f setDateFormat:@"yyyy年MM月dd日"];
        prefix = @"";
    }
    return [NSString stringWithFormat:@"%@%@", prefix, [f stringFromDate:self]];
}

- (NSString*)timeDifferenceString {
    
    NSDate *currentDate = [NSDate fixedDate];

    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self];
    NSString *timeStr;
    if (timeInterval < 60) {
        if (timeInterval <= 0) {
            timeStr = @"刚刚";
        } else {
            timeStr = [NSString stringWithFormat:@"%.0f秒前", timeInterval];
        }
    } else if (timeInterval < 60*60) {
        timeStr = [NSString stringWithFormat:@"%.0f分钟前", timeInterval/60];
    } else {
        if ([self isSameDayAsDate:currentDate.yesterdayBeginTime]) {
            timeStr = @"昨天";
        } else if (timeInterval < 24*60*60) {
            timeStr = [NSString stringWithFormat:@"%.0f小时前", timeInterval/(60*60)];
        } else {
            CGFloat day = timeInterval/(24*60*60);
            timeStr = [NSString stringWithFormat:@"%.0f天前", day];
        }
        
    }
    return timeStr;
}


- (NSString *)timeDifferenceOrRelativeTimeString {
    
    NSDate *currentDate = [NSDate fixedDate];
    
    if ([self isSameDayAsDate:currentDate]) {
        return [self timeDifferenceString];
    } else {
        return [self relativeTimeString];
    }
}

- (NSString *)weekString {
    return [NSString stringWithFormat:@"第%ld周", (long)self.dateComponents.weekOfYear];
}

#pragma mark - switch

- (NSDate *)todayBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)todayEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)yesterdayBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:self.dateComponents.day - 1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)yesterdayEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:self.dateComponents.day - 1];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)theDayBeforeYesterdayBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:self.dateComponents.day - 2];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)theDayBeforeYesterdayEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:self.dateComponents.day - 2];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)endTimeAfterDays:(NSUInteger)days {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:self.dateComponents.day + days];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)weekBeginTime {
    NSDateComponents *components  = [self dateComponents];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
    
    NSInteger weekBeginOffset;
    if (components.weekday == 1){
        weekBeginOffset = 6;
    }
    else
    {
        weekBeginOffset = components.weekday - 2;
    }

    [components setDay:(components.day - weekBeginOffset)];// for beginning of the week.
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *beginningOfWeek = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate  *weekstartPrev = [dateFormat dateFromString:dateString2Prev];
    
    return weekstartPrev;
}

- (NSDate *)weekEndTime {
    NSDateComponents *components  = [self dateComponents];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSInteger weekEndOffset;
    if (components.weekday == 1){
        weekEndOffset = 0;
    }
    else
    {
        weekEndOffset =  8 - components.weekday;
    }
    
    [components setDay:(components.day + weekEndOffset)];// for endding of the week.
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    NSDate *beginningOfWeek = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    NSDate  *weekEndPrev = [dateFormat dateFromString:dateString2Prev];
    
    return weekEndPrev;
}

- (NSDate *)monthBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)monthEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setYear:self.dateComponents.year];
    [components setMonth:self.dateComponents.month];
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    [components setDay:days.length];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)lastMonthBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setMonth:self.dateComponents.month-1];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)lastMonthEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setDay:0];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)quarterBeginTime {
    NSDateComponents *components  = [self dateComponents];
    [components setMonth: ((self.dateComponents.month  - 1) / 3) * 3 + 1];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)quarterEndTime {
    NSDateComponents *components  = [self dateComponents];
    [components setMonth:((self.dateComponents.month  - 1) / 3) * 3 + 3 + 1];
    [components setDay:0];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateInMonthWithDay:(NSUInteger )day {
    NSDateComponents *components  = [self dateComponents];
    [components setYear:self.dateComponents.year];
    [components setMonth:self.dateComponents.month];
    [components setDay:day];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end
