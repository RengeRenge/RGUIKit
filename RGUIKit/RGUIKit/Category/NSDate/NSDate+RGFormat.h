//
//  NSDate+Format.h
//  liangbo-ios
//
//  Created by renge on 2018/7/24.
//  Copyright © 2018年 tong zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RGWeekSun = 1,
    RGWeekMon,
    RGWeekTue,
    RGWeekWed,
    RGWeekThu,
    RGWeekFri,
    RGWeekSat,
} RGWeek;

@interface NSDate (RGFormat)

/**
 dateString to date
 
 @param format like yyyyMMddHHmmss
 */
+ (NSDate *)rg_GMTDateWithString:(NSString *)dateString dateFormat:(NSString *)format;

/// dateString to local date
/// @param format like yyyyMMddHHmmss
+ (NSDate *)rg_localDateWithString:(NSString *)dateString dateFormat:(NSString *)format;


/// dateString to date
/// @param format like yyyyMMddHHmmss
/// @param timeZone timeZone
+ (NSDate *)rg_dateWithString:(NSString *)dateString dateFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;


/**
 date to dateString
 
 @param format like yyyyMMddHH
 */
- (NSString *)rg_stringWithDateFormat:(NSString *)format;


+ (RGWeek)rg_weekday;

+ (NSDate * _Nullable)rg_currentWeekDateOfWeek:(RGWeek)week;

/**
 get today date 00:00:00
 */
+ (NSDate *)rg_today;

/// get first date of month
+ (NSDate *)rg_firstDateOfMonth:(NSDate *)month;

/// get first date of year
+ (NSDate *)rg_firstDateOfYear:(NSDate *)year;

/// get  date at 00:00:00
- (NSDate *)rg_today;

@end

NS_ASSUME_NONNULL_END
