//
//  NSDate+Category.h
//  XCSX
//
//  Created by hcsx on 2017/8/23.
//  Copyright © 2017年 hcsx. All rights reserved.
//

#import <Foundation/Foundation.h>
#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Category)
+ (NSDateFormatter *)cachedDateFormatter;
+(NSTimeInterval)getCurrentTimestamp;
+ (NSString *)secondsDescriptionWithTimeInterval:(NSTimeInterval)time;
- (NSString *)b_timeIntervalDescription;//距离当前的时间间隔描述
- (NSString *)minuteDescription;/*精确到分钟的日期描述*/
- (NSString *)formattedTime;
//- (NSString *)formattedTimeWithFull:(BOOL)isFull;
- (NSString *)formattedDateDescription;//格式化日期描述

+(NSInteger)getAgeFromDate:(NSDate *)birDate;

- (NSString *)formattedLeftTimeDescription;//剩余xx时间结束
- (double)timeIntervalSince1970InMilliSecond;
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;
+ (NSString *)formattedTimeFromTimeInterval:(long long)time isFull:(BOOL)isFull;
+ (NSString *)formattedTimeFromReferenceTimeInterval:(long long)time isFull:(BOOL)isFull;
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isInFuture;
- (BOOL) isInPast;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

+ (NSString *)getStrDateByDate:(NSDate *)date format:(NSString *)format;
//相差天数
+(NSInteger)componetsDayWithBeginStr:(NSString *)beginStr endStr:(NSString *)endStr dateFormat:(NSString *)dateFormat;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger b_nearestHour;
@property (readonly) NSInteger b_hour;
@property (readonly) NSInteger b_minute;
@property (readonly) NSInteger b_seconds;
@property (readonly) NSInteger b_day;
@property (readonly) NSInteger b_month;
@property (readonly) NSInteger b_week;
@property (readonly) NSInteger b_weekday;
@property (readonly) NSInteger b_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger b_year;



+(NSDate *)getDateWithStr:(NSString *)str dateFormat:(NSString *)dateFormat;
//世界时间转换为本地时间
+(NSDate *)worldDateToLocalDate:(NSDate *)date;

+ (NSDate *)easyDateFormatterWithString:(NSString *)string ;

@end
