//
//  RGTimePicker.h
//  RGTimePicker
//
//  Created by renge on 2018/10/18.
//  Copyright © 2018年 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGTimePicker : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSInteger minTime;
@property (nonatomic, assign) NSInteger maxTime;

@property (nonatomic, assign) BOOL nextDay;

@property (nonatomic, assign) NSInteger currentTime;

+ (void)showWithTitle:(nullable NSString *)title
          defaultTime:(NSInteger)defaultTime
              nextDay:(BOOL)nextDay
              minTime:(NSInteger)minTime
              maxTime:(NSInteger)maxTime
               commit:(nullable void (^)(NSInteger time))commit
               cancel:(nullable void (^)(void))cancel;

@end

NS_ASSUME_NONNULL_END
