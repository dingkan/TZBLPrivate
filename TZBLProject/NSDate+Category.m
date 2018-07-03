//
//  NSDate+Category.m
//  XCSX
//
//  Created by hcsx on 2017/8/23.
//  Copyright © 2017年 hcsx. All rights reserved.
//

#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"

#define DATE_COMPONENTS (NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Category)

static NSDateFormatter *dateFormatter = nil;
+ (NSDateFormatter *)cachedDateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    }
    return dateFormatter;
}

+(NSTimeInterval)getCurrentTimestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    return a;
}

+ (NSString *)secondsDescriptionWithTimeInterval:(NSTimeInterval)time {
    int hour = 0.f;
    int minute = 0.f;
    int second = 0.f;
    hour = time/3600;
    minute = (time - hour*3600)/60;
    second = time - minute*60 - hour*3600;
    NSString *result = nil;
    
    if (hour > 0) {
        result = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }else {
        result = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
    return result;
}
/*距离当前的时间间隔描述*/
- (NSString *)b_timeIntervalDescription
{
    NSTimeInterval timeInterval = - [self timeIntervalSinceNow] + 28800;
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
    } else if (timeInterval < 86400) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
    } else if (timeInterval < 604800) {//7天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / 86400];
    } else if (timeInterval < 31536000) {//7天至1年内
//        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月d日"];
        NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
        dateFormatter.dateFormat = @"M月d日";
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}

// 时间转字符串 format = @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)getStrDateByDate:(NSDate *)date format:(NSString *)format
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    dateFormatter.dateFormat = format;
    NSString *currentTime = [dateFormatter stringFromDate:date];
    
    return currentTime;
}

+(NSInteger)componetsDayWithBeginStr:(NSString *)beginStr endStr:(NSString *)endStr dateFormat:(NSString *)dateFormat {
//    NSDateFormatter *form = [[NSDateFormatter alloc]init];
//    form.locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    dateFormatter.dateFormat = dateFormat;//@"YYYY-MM-dd HH:mm:ss";

    NSDate *beginDate = [dateFormatter dateFromString:beginStr];
    NSDate *endDate = [dateFormatter dateFromString:endStr];
    
//    NSDate *beginDate = [self easyDateFormatterWithString:beginStr];
//    NSDate *endDate = [self easyDateFormatterWithString:endStr];
    
    NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
//    
//    int hours = ((int)time)%(3600*24)/3600;
//    
//    int minutes = ((int)time)%(3600*24)%3600/60;
//    
//    int seconds = ((int)time)%(3600*24)%3600%60;
    
//    NSString *dateContent = [[NSString alloc] initWithFormat:@"仅剩%i天%i小时%i分%i秒",days,hours,minutes,seconds];
    return days;
}

+(NSDate *)getDateWithStr:(NSString *)str dateFormat:(NSString *)dateFormat{
    
//    NSDateFormatter *form = [[NSDateFormatter alloc]init];
//    [form setLocale:[NSLocale currentLocale]];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
     [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    dateFormatter.dateFormat = dateFormat;//@"YYYY-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:str];
}

/*精确到分钟的日期描述*/
- (NSString *)minuteDescription
{
//    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
//    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7) {//间隔一周内
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

/*标准时间日期描述*/
-(NSString *)formattedTime{
//    NSDateFormatter* formatter2 = [[NSDateFormatter alloc]init];
//    [formatter2 setDateFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd 00:00:00";
    NSString * dateNow = [dateFormatter stringFromDate:[NSDate date]];
    //    NSDateComponents *components = [[NSDateComponents alloc] init];
    //    [components setDay:[[dateNow substringWithRange:NSMakeRange(8,2)] intValue]];
    //    [components setMonth:[[dateNow substringWithRange:NSMakeRange(5,2)] intValue]];
    //    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date= [dateFormatter dateFromString:dateNow];
    
    
    NSInteger hour = [self hoursAfterDate:date];
//    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
            [dateFormatter setDateFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
            [dateFormatter setDateFormat:@"昨天HH:mm"];
        }else {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
    }else {
        if (hour >= 0 && hour <= 6) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"凌晨hh:mm"];
            [dateFormatter setDateFormat:@"凌晨hh:mm"];
        }else if (hour > 6 && hour <=11 ) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
            [dateFormatter setDateFormat:@"上午hh:mm"];
        }else if (hour > 11 && hour <= 17) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
            [dateFormatter setDateFormat:@"下午hh:mm"];
        }else if (hour > 17 && hour <= 24) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"晚上hh:mm"];
            [dateFormatter setDateFormat:@"晚上hh:mm"];
        }else if (hour < 0 && hour >= -24){
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
            [dateFormatter setDateFormat:@"昨天HH:mm"];
        }else  {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        
    }
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    ret = [dateFormatter stringFromDate:self];
    return ret;
}

/*标准时间日期描述*/
-(NSString *)formattedTimeWithFull:(BOOL)isFull timeZone:(NSString *)timezomes{
    
    
//    NSDateFormatter* formatter2 = [[NSDateFormatter alloc]init];
//    [formatter2 setDateFormat:@"yyyyMMdd 00:00:00"];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd 00:00:00";
    
    NSString * dateNow = [dateFormatter stringFromDate:[NSDate date]];
    //    NSDateComponents *components = [[NSDateComponents alloc] init];
    //    [components setTimeZone:[NSTimeZone localTimeZone]];
    //    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    //    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    //    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    //    [components setHour:8];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *date= [dateFormatter dateFromString:dateNow];
    
    NSInteger hour = [self hoursAfterDate:date];
//    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
            [dateFormatter setDateFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24) {
            if (isFull) {
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
            }else{
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天"];
                [dateFormatter setDateFormat:@"昨天"];
            }
        }else {
            if (isFull) {
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            }else{
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yy/MM/dd"];
                [dateFormatter setDateFormat:@"yy/MM/dd"];
            }
        }
    }else {
        if (hour >= 0 && hour <= 6) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"凌晨hh:mm"];
            [dateFormatter setDateFormat:@"凌晨hh:mm"];
        }else if (hour > 6 && hour <=11 ) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
            [dateFormatter setDateFormat:@"上午hh:mm"];
        }else if (hour > 11 && hour <= 17) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
            [dateFormatter setDateFormat:@"下午hh:mm"];
        }else if (hour > 17 && hour <= 24) {
//            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"晚上hh:mm"];
            [dateFormatter setDateFormat:@"晚上hh:mm"];
        }else if (hour < 0 && hour >= -24){
            if (isFull) {
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
            }else{
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天"];
                [dateFormatter setDateFormat:@"昨天"];
            }
        }else  {
            if (isFull) {
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            }else{
//                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yy/MM/dd"];
                [dateFormatter setDateFormat:@"yy/MM/dd"];
            }
        }
        
    }
    if (timezomes) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezomes]];
    }
    ret = [dateFormatter stringFromDate:self];
    return ret;
}


/*格式化日期描述*/
/**/
- (NSString *)formattedDateDescription
{
    NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    //    timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval interval = [timeZone secondsFromGMT];
    NSDate *GMTDate = [self dateByAddingTimeInterval:-interval];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    [dateFormatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
    
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = - [GMTDate timeIntervalSinceNow];
    if (timeInterval < 0) {
        return @"遥远的未来";
    }
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟前", (long)(timeInterval / 60)];
    } else if (timeInterval < 21600) {//6小时内
        return [NSString stringWithFormat:@"%ld小时前", (long)(timeInterval / 3600)];
    } else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

/**/
- (NSString *)formattedLeftTimeDescription {
    
    //    NSTimeZone *timeZone = [[NSTimeZone alloc] init];
    //    timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //    NSTimeInterval interval = [timeZone secondsFromGMT];
    //    NSDate *GMTDate = [self dateByAddingTimeInterval:-interval];
    //
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //
    //    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    //    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    //
    //    NSInteger timeInterval = -[GMTDate timeIntervalSinceNow];
    
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval interval = [timeZone secondsFromGMT];
    NSDate *GMTDate = [self dateByAddingTimeInterval:-interval];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter = [NSDate cachedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSInteger timeInterval = -[GMTDate timeIntervalSinceNow];
    
    if (timeInterval < 0) {
        return @"-1";
    }
    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"%ld秒",timeInterval];
    } else if (timeInterval < 3600) {//1小时内
        return [NSString stringWithFormat:@"%ld分钟", (long)(timeInterval / 60)];
    } else if (timeInterval < 86400) {//24小时内
        return [NSString stringWithFormat:@"%ld小时", (long)(timeInterval / 3600)];
    }else{//以前
        return [NSString stringWithFormat:@"%ld天", (long)(timeInterval / 86400)];
    }
}

- (double)timeIntervalSince1970InMilliSecond {
    double ret;
    ret = [self timeIntervalSince1970] * 1000;
    
    return ret;
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)time isFull:(BOOL)isFull{
    return [[NSDate dateWithTimeIntervalInMilliSecondSince1970:time] formattedTimeWithFull:isFull timeZone:nil];
}
+ (NSString *)formattedTimeFromReferenceTimeInterval:(long long)time isFull:(BOOL)isFull{
    return [[NSDate dateWithTimeIntervalSinceReferenceDate:time] formattedTimeWithFull:isFull timeZone:@"UTC"];
}

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (components1.week != components2.week) return NO;
    
#pragma clang diagnostic pop
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}



#pragma mark Decomposing Dates

- (NSInteger) b_nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) b_hour
{
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger) b_minute
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger) b_seconds
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger) b_day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger) b_month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.week;
}

- (NSInteger) b_weekday
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger) b_nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) b_year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

+(NSInteger)getAgeFromDate:(NSDate *)birDate{
    NSDate *now = [NSDate date];
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birDate toDate:now options:0] year];
    
}

//世界时间转换为本地时间
+(NSDate *)worldDateToLocalDate:(NSDate *)date
{
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:offset];
    
    return localDate;
}

+ (NSDate *)easyDateFormatterWithString:(NSString *)string {
    
    if (!string) return nil;
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    
    struct tm tm;
    time_t t;
    
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    //    return [NSDate dateWithTimeIntervalSince1970:t]; // 零时区
    return [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];//东八区
}




@end
