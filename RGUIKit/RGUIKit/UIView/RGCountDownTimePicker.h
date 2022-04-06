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
    RGCountDownTimePickerTypeHours = 1 << 1,
    RGCountDownTimePickerTypeMin = 1 << 2,
    RGCountDownTimePickerTypeSec = 1 << 3,
} RGCountDownTimePickerType;

/// Count down time picker. All time property 's unit is second.
@interface RGCountDownTimePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger minimumTime;
@property (nonatomic, assign) NSInteger maximumTime;

@property (nonatomic, assign) RGCountDownTimePickerType pickerType;

@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) NSInteger step;

- (void)setUnit:(NSString *)unit forPickerType:(RGCountDownTimePickerType)type;
- (void)setSplit:(NSString *)split forPickerType:(RGCountDownTimePickerType)type;

@property (nonatomic, copy, nullable) void(^change)(RGCountDownTimePicker *picker, NSInteger time);

+ (void)showWithDefaultTime:(NSInteger)defaultTime
                      title:(NSString *)title
                commitTitle:(NSString *)commitTitle
                cancelTitle:(NSString *)cancelTitle
                     config:(void(^)(RGCountDownTimePicker *picker))config
                     change:(nullable void (^)(RGCountDownTimePicker *picker, NSInteger time))change
                     commit:(nullable void (^)(RGCountDownTimePicker *picker, NSInteger time))commit
                     cancel:(nullable void (^)(RGCountDownTimePicker *picker))cancel;

@end

NS_ASSUME_NONNULL_END
