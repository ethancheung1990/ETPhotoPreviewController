//
//  NSDate+Category.h
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

+ (void)setStandardTime:(NSDate *)standardTime;

+ (NSDate *)fixedDate;

- (NSDateComponents *)dateComponents;

#pragma mark - compare

-(BOOL)isEarlizerThanDate:(NSDate *)dt;

-(BOOL)isLaterThanDate:(NSDate *)dt;

-(BOOL)isSameYearAsDate:(NSDate *)dt;

-(BOOL)isSameMonthAsDate:(NSDate *)dt;

-(BOOL)isSameWeekAsDate:(NSDate *)dt;

-(BOOL)isSameDayAsDate:(NSDate *)dt;

#pragma mark - format

- (NSString *)toISO8601;

- (NSString *)toYYYYMMdd;

- (NSString *)toYYYYMMDDhhmmss;

- (NSString *)toYYYY_MM_DD_hh_mm_ss;

- (NSString *)tohh_mm;

- (NSString *)toYYYY_MM_DD;

- (NSString *)toYYYYMM;

- (NSString *)toYYYY_MM;

- (NSString *)toMM_DD;

- (NSString*)toMM_DD_HH_mm;

- (NSString*)toMM_DD_HH_mm_OR_yyyy_MM_DD_HH_mm;

- (NSString*)toyyyy_MM_DD_HH_mm;

- (NSString*)toMM_DD_OR_yyyy_MM_DD;

- (NSString*)relativeTimeString;

- (NSString*)timeDifferenceString;

- (NSString *)timeDifferenceOrRelativeTimeString;

- (NSString *)weekString;

#pragma mark - switch

- (NSDate *)todayBeginTime;

- (NSDate *)todayEndTime;

- (NSDate *)yesterdayBeginTime;

- (NSDate *)yesterdayEndTime;

- (NSDate *)theDayBeforeYesterdayBeginTime;

- (NSDate *)theDayBeforeYesterdayEndTime;

- (NSDate *)endTimeAfterDays:(NSUInteger)days;

- (NSDate *)weekBeginTime;

- (NSDate *)weekEndTime;

- (NSDate *)monthBeginTime;

- (NSDate *)monthEndTime;

- (NSDate *)lastMonthBeginTime;

- (NSDate *)lastMonthEndTime;

- (NSDate *)quarterBeginTime;

- (NSDate *)quarterEndTime;

- (NSDate *)dateInMonthWithDay:(NSUInteger )day;

@end
