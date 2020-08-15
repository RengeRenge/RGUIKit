//
//  NSDate+Format.m
//  liangbo-ios
//
//  Created by renge on 2018/7/24.
//  Copyright © 2018年 tong zhang. All rights reserved.
//

#import "NSDate+RGFormat.h"

@implementation NSDate (RGFormat)

- (NSString *)rg_stringWithDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

+ (NSDate *)rg_GMTDateWithString:(NSString *)dateString dateFormat:(NSString *)format {
    return [NSDate rg_dateWithString:dateString dateFormat:format timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

+ (NSDate *)rg_localDateWithString:(NSString *)dateString dateFormat:(NSString *)format {
    return [NSDate rg_dateWithString:dateString dateFormat:format timeZone:[NSTimeZone localTimeZone]];
}

+ (NSDate *)rg_dateWithString:(NSString *)dateString dateFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    dateFormatter.timeZone = timeZone;
    return [dateFormatter dateFromString:dateString];
}

+ (RGWeek)rg_weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday
                                         fromDate:[NSDate date]];
    return [comp weekday];
}

+ (NSDate * _Nullable)rg_currentWeekDateOfWeek:(RGWeek)week {
    if (week <= 0 || week > 7) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday
                                         fromDate:[NSDate date]];
    NSDate *date = [calendar dateFromComponents:comp];
    return [date dateByAddingTimeInterval:(week - 1) * 24 * 60 * 60];
}

+ (NSDate *)rg_today {
    return [[NSDate date] rg_today];
}

+ (NSDate *)rg_firstDateOfMonth:(NSDate *)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp = [calendar components:NSCalendarUnitMonth
                                         fromDate:month];
    return [calendar dateFromComponents:comp];
}

+ (NSDate *)rg_firstDateOfYear:(NSDate *)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear
                                         fromDate:year];
    return [calendar dateFromComponents:comp];
}

- (NSDate *)rg_today {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale currentLocale];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                         fromDate:self];
    return [calendar dateFromComponents:comp];
}

@end
