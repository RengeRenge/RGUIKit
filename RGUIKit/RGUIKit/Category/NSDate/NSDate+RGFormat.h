//
//  NSDate+Format.h
//  liangbo-ios
//
//  Created by renge on 2018/7/24.
//  Copyright © 2018年 tong zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 
 @param format like yyyyMMddHH
 */
+ (NSDate *)rg_dateWithString:(NSString *)dateString dateFormat:(NSString *)format;


/**
 date to dateString
 
 @param format like yyyyMMddHH
 */
- (NSString *)rg_stringWithDateFormat:(NSString *)format;


+ (RGWeek)rg_weekday;

+ (NSDate * _Nullable)rg_WeekDateWithWeek:(RGWeek)week;

/**
 get today date 00:00:00
 */
+ (NSDate *)rg_today;


@end
