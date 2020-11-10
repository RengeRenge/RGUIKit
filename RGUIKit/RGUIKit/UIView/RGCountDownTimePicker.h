//
//  RGCountDownTimePicker.h
//  RGCountDownTimePicker
//
//  Created by renge on 2018/10/18.
//  Copyright © 2018年 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RGTimePickerTypeHour = 1 << 1,
    RGTimePickerTypeMinute = 1 << 2,
    RGTimePickerTypeSecond = 1 << 3,
} RGTimePickerType;


/// Count down time picker. All time property 's unit is second.
@interface RGCountDownTimePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger minTime;
@property (nonatomic, assign) NSInteger maxTime;

@property (nonatomic, assign) RGTimePickerType pickerType;

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *commitTitle;
@property (nonatomic, copy) NSString *cancelTitle;

+ (void)showWithDefaultTime:(NSInteger)defaultTime
                     config:(void(^)(RGCountDownTimePicker *picker))config
                     change:(nullable void (^)(RGCountDownTimePicker *picker, NSInteger time))change
                     commit:(nullable void (^)(RGCountDownTimePicker *picker, NSInteger time))commit
                     cancel:(nullable void (^)(RGCountDownTimePicker *picker))cancel;

@end

NS_ASSUME_NONNULL_END
