//
//  RGCountDownTimePicker.m
//  RGCountDownTimePicker
//
//  Created by renge on 2018/10/18.
//  Copyright © 2018年 ld. All rights reserved.
//

#import "RGCountDownTimePicker.h"

NSInteger RGTimePickerDayTimeInterval = 24 * 60 * 60;

//#define _RGTimePickerDayTimeInterval (RGTimePickerDayTimeInterval - (_nextDay ? 0 : 1))
#define _RGTimePickerDayTimeInterval ((self.pickerType & RGTimePickerTypeHour) ? RGTimePickerDayTimeInterval : ((self.pickerType & RGTimePickerTypeMinute) ? 60*60 : 60))

static UIWindow *RGTimePickerWindow = nil;
static RGCountDownTimePicker *RGTimePickerShared = nil;
static UIToolbar *RGTimePickerToolBarShared = nil;

static void(^RGTimePickerChange)(RGCountDownTimePicker *, NSInteger);
static void(^RGTimePickerCommit)(RGCountDownTimePicker *, NSInteger);
static void(^RGTimePickerCancel)(RGCountDownTimePicker *);

@interface RGCountDownTimePicker ()

//@property (nonatomic, assign) BOOL nextDay;

@property (nonatomic, assign) NSInteger minMinute;
@property (nonatomic, assign) NSInteger minHour;
@property (nonatomic, assign) NSInteger minSecond;

@property (nonatomic, assign) NSInteger maxMinute;
@property (nonatomic, assign) NSInteger maxHour;
@property (nonatomic, assign) NSInteger maxSecond;

@property (nonatomic, assign) NSInteger currentHour;
@property (nonatomic, assign) NSInteger currentMinute;
@property (nonatomic, assign) NSInteger currentSecond;

@property (nonatomic, strong) NSArray <NSNumber *> *steps;

@property (nonatomic, strong) NSArray <NSNumber *> *types;

@property (nonatomic, strong) UIBarButtonItem *titleItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;
@property (nonatomic, strong) UIBarButtonItem *okItem;

@end

@implementation RGCountDownTimePicker
@synthesize currentTime = _currentTime;

#pragma mark - Window

+ (void)showWithDefaultTime:(NSInteger)defaultTime
                     config:(nonnull void (^)(RGCountDownTimePicker * _Nonnull))config
                     change:(nullable void (^)(RGCountDownTimePicker * _Nonnull, NSInteger))change
                     commit:(nullable void (^)(RGCountDownTimePicker * _Nonnull, NSInteger))commit
                     cancel:(nullable void (^)(RGCountDownTimePicker * _Nonnull))cancel {
    if (!RGTimePickerWindow) {
        RGTimePickerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [RGTimePickerWindow setWindowLevel:UIWindowLevelAlert];
    }
    UIWindow *window = RGTimePickerWindow;
    
    if (!window.rootViewController) {
        UIViewController *vc = [[UIViewController alloc] init];
        window.rootViewController = vc;
    }
    
    if (!RGTimePickerShared) {
        
        UIViewController *vc = window.rootViewController;
        
        UIView *bgView = [[UIView alloc] initWithFrame:vc.view.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [bgView addGestureRecognizer:tap];
        [vc.view addSubview:bgView];
        
        CGFloat height = 280.f;
        
        CGRect bounds = vc.view.bounds;
        bounds.origin.y = bounds.size.height;
        bounds.size.height = height;
        
        UIView *wapper = [[UIView alloc] initWithFrame:bounds];
        wapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [window.rootViewController.view addSubview:wapper];
        
        // picker
        bounds = UIEdgeInsetsInsetRect(wapper.bounds, UIEdgeInsetsMake(40, 0, 0, 0));
        RGTimePickerShared = [[RGCountDownTimePicker alloc] initWithFrame:bounds];
        RGTimePickerShared.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        RGTimePickerShared.backgroundColor = [UIColor whiteColor];
        
        // tool
        bounds = UIEdgeInsetsInsetRect(wapper.bounds, UIEdgeInsetsMake(40, 0, 0, 0));
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 40)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        toolbar.backgroundColor = [UIColor whiteColor];
        toolbar.translucent = NO;
        [wapper addSubview:RGTimePickerShared];
        [wapper addSubview:toolbar];
        
        RGTimePickerToolBarShared = toolbar;
        
        bgView.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect bounds = window.rootViewController.view.bounds;
            bounds.origin.y = bounds.size.height - height;
            bounds.size.height = height;
            wapper.frame = bounds;
            
            bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
        }];
    }
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"时间选择" style:UIBarButtonItemStylePlain target:nil action:nil];
    titleItem.enabled = NO;
    
    UIBarButtonItem *fix1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    RGTimePickerToolBarShared.items = @[cancelItem, fix1, titleItem, fix2, okItem];
    
    RGTimePickerShared.step = 1;
    RGTimePickerShared.titleItem = titleItem;
    RGTimePickerShared.okItem = okItem;
    RGTimePickerShared.cancelItem = cancelItem;
    if (config) {
        config(RGTimePickerShared);
    }
    RGTimePickerShared.currentTime = defaultTime;
    
    RGTimePickerChange = change;
    RGTimePickerCommit = commit;
    RGTimePickerCancel = cancel;
    [RGTimePickerShared reloadAllComponents];
    window.hidden = NO;
}

+ (void)dismiss:(void(^)(void))completion {
    UIView *wapper = RGTimePickerShared.superview;
    [UIView animateWithDuration:0.3 animations:^{
        wapper.frame = CGRectOffset(wapper.frame, 0, wapper.frame.size.height);
    } completion:^(BOOL finished) {
        
        RGTimePickerWindow.hidden = YES;
        RGTimePickerWindow.rootViewController = nil;
        [RGTimePickerShared removeFromSuperview];
        [RGTimePickerToolBarShared removeFromSuperview];
        RGTimePickerToolBarShared = nil;
        RGTimePickerShared = nil;
        
        if (completion) {
            completion();
        }
    }];
}

+ (void)ok {
    
    void(^RGTimePickerBlockTemp)(RGCountDownTimePicker *, NSInteger) = RGTimePickerCommit;
    RGTimePickerChange = nil;
    RGTimePickerCommit = nil;
    RGTimePickerCancel = nil;
    
    NSInteger time = RGTimePickerShared.currentTime;
    
    [self dismiss:^{
        if (RGTimePickerBlockTemp) {
            RGTimePickerBlockTemp(RGTimePickerShared, MIN(time, RGTimePickerDayTimeInterval));
        }
    }];
}

+ (void)cancel {
    
    void(^RGTimePickerBlockTemp)(RGCountDownTimePicker *) = RGTimePickerCancel;
    RGTimePickerChange = nil;
    RGTimePickerCommit = nil;
    RGTimePickerCancel = nil;
    
    [self dismiss:^{
        if (RGTimePickerBlockTemp) {
            RGTimePickerBlockTemp(RGTimePickerShared);
        }
    }];
}

#pragma mark - TimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        _steps = @[@1, @1, @1];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleItem.title = title;
}

- (void)setCommitTitle:(NSString *)commitTitle {
    _commitTitle = commitTitle;
    _okItem.title = commitTitle;
}

- (void)setCancelTitle:(NSString *)cancelTitle {
    _cancelTitle = cancelTitle;
    _cancelItem.title = cancelTitle;
}

//- (void)setNextDay:(BOOL)nextDay {
//    _nextDay = nextDay;
//}

- (void)setMinTime:(NSInteger)minTime {
    
    _minTime = MIN(minTime, _RGTimePickerDayTimeInterval);
    
    self.minHour = _minTime / 3600;
    self.minMinute = (_minTime - self.minHour * 3600) / 60;
    self.minSecond = _minTime % 60;
    if (_currentTime < _minTime) {
        self.currentTime = _minTime;
    } else {
        [self reloadAllComponents];
    }
}

- (void)setStep:(NSInteger)step {
    _step = step;
    _steps = @[
        @(step < 60 ? step%60 : 1),
        @((step >= 60 && step < 3600) ? (step/60)%60 : 1),
        @((step >= 3600 ? (step/3600)%60 : 1))
    ];
}

- (void)setMaxTime:(NSInteger)maxTime {
    
    _maxTime = MIN(maxTime, _RGTimePickerDayTimeInterval);
    
    self.maxHour = _maxTime / 3600;
    self.maxMinute = (_maxTime - self.maxHour * 3600) / 60;
    self.maxSecond = _maxTime % 60;
    
    [self reloadAllComponents];
}

- (void)setCurrentTime:(NSInteger)currentTime {
    if (currentTime < self.minTime) {
        return;
    }
    currentTime = MAX(MIN(currentTime, self.maxTime), self.minTime);
    self.currentHour = currentTime / 3600;
    self.currentMinute = (currentTime - self.currentHour * 3600) / 60;
    self.currentSecond = currentTime % 60;
    [self reloadAllComponents];
    
    NSUInteger index = [self.types indexOfObject:@(RGTimePickerTypeHour)];
    if (index != NSNotFound) {
        [self selectRow:MAX(0, _currentHour - _minHour) / _steps[2].intValue inComponent:index animated:YES];
    }
    
    if (_currentHour == _minHour) {
        NSUInteger index = [self.types indexOfObject:@(RGTimePickerTypeMinute)];
        if (index != NSNotFound) {
            [self selectRow:MAX(0, _currentMinute - _minMinute) / _steps[1].intValue inComponent:index animated:YES];
        } else {
            
        }
    } else {
        NSUInteger index = [self.types indexOfObject:@(RGTimePickerTypeMinute)];
        if (index != NSNotFound) {
            [self selectRow:_currentMinute / _steps[1].intValue inComponent:index animated:YES];
        }
    }
    
    if (_currentMinute == _minMinute) {
        NSUInteger index = [self.types indexOfObject:@(RGTimePickerTypeSecond)];
        if (index != NSNotFound) {
            [self selectRow:MAX(0, _currentSecond - _minSecond) / _steps[0].intValue inComponent:index animated:YES];
        }
    } else {
        NSUInteger index = [self.types indexOfObject:@(RGTimePickerTypeSecond)];
        if (index != NSNotFound) {
            [self selectRow:_currentSecond / _steps[0].intValue inComponent:index animated:YES];
        }
    }
}

- (NSInteger)currentTime {
    __block NSInteger time = 0;
    [self.types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RGTimePickerType type = obj.unsignedIntegerValue;
        switch (type) {
            case RGTimePickerTypeHour:
                time += _currentHour*3600;
                break;
            case RGTimePickerTypeMinute:
                time += _currentMinute*60;
                break;
            case RGTimePickerTypeSecond:
                time += _currentSecond;
                break;
            default:
                break;
        }
    }];
    return time;
}

- (void)setCurrentHour:(NSInteger)currentHour {
    _currentHour = MIN(24, MAX(0, currentHour));
    _currentTime = (_currentHour * 60 + _currentMinute) * 60;
}

- (void)setCurrentMinute:(NSInteger)currentMinute {
    _currentMinute = MIN(59, MAX(0, currentMinute));
    _currentTime = (_currentHour * 60 + _currentMinute) * 60;
}

- (void)setPickerType:(RGTimePickerType)pickerType {
    _pickerType = pickerType;
    
    NSMutableArray *array = [NSMutableArray array];
    if (_pickerType & RGTimePickerTypeHour) {
        [array addObject:@(RGTimePickerTypeHour)];
    }
    if (_pickerType & RGTimePickerTypeMinute) {
        [array addObject:@(RGTimePickerTypeMinute)];
    }
    if (_pickerType & RGTimePickerTypeSecond) {
        [array addObject:@(RGTimePickerTypeSecond)];
    }
    self.types = array;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return self.types.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 60;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    RGTimePickerType type = [self.types[component] unsignedIntegerValue];
    NSInteger number = 0;
    
    NSInteger start = 0;
    NSInteger end = 59;
    NSInteger step = 1;
    
    if (type == RGTimePickerTypeHour) {
        step = _steps[2].intValue;
        start = self.minHour;
        end = self.maxHour;
    }
    
    if (type == RGTimePickerTypeMinute) {
        step = _steps[1].intValue;
        end = 59;
        if (self.currentHour == self.maxHour) {
            end = self.maxMinute;
        }
        if (self.currentHour == self.minHour) {
            start = self.minMinute;
        }
    }
    
    if (type == RGTimePickerTypeSecond) {
        step = _steps[0].intValue;
        end = 59;
        if (self.currentMinute == self.maxMinute && self.currentHour == self.maxHour) {
            end = self.maxSecond;
        }
        if (self.currentMinute == self.minMinute && self.currentHour == self.minHour) {
            start = self.minSecond;
        }
    }
    
    number = (end - start) / step + 1;
    return number;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    RGTimePickerType type = [self.types[component] unsignedIntegerValue];
    
    if (type == RGTimePickerTypeHour) {
        row *= self.steps[2].intValue;
        return [NSString stringWithFormat:@"%02ld", (long)self.minHour + row];
    }
    if (type == RGTimePickerTypeMinute) {
        row *= self.steps[1].intValue;
        if (self.currentHour == self.minHour) {
            return [NSString stringWithFormat:@"%02ld", (long)row + self.minMinute];
        }
        return [NSString stringWithFormat:@"%02ld", (long)row];
    }
    if (type == RGTimePickerTypeSecond) {
        row *= self.steps[0].intValue;
        if (self.currentMinute == self.minMinute && self.currentHour == self.minHour) {
            return [NSString stringWithFormat:@"%02ld", (long)row + self.minSecond];
        }
        return [NSString stringWithFormat:@"%02ld", (long)row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    RGTimePickerType type = [self.types[component] unsignedIntegerValue];
    
    if (type == RGTimePickerTypeHour) {
        row *= self.steps[2].intValue;
        self.currentHour = self.minHour + row;
        
        NSInteger minIndex = [self.types indexOfObject:@(RGTimePickerTypeMinute)];
        if (minIndex != NSNotFound) {
            [self fixCurrentMinuteInComponent:minIndex picker:pickerView];
        }
        
        NSInteger secIndex = [self.types indexOfObject:@(RGTimePickerTypeSecond)];
        if (secIndex != NSNotFound) {
            [self fixCurrentSecondInComponent:secIndex picker:pickerView];
        }
    }
    if (type == RGTimePickerTypeMinute) {
        row *= self.steps[1].intValue;
        [self fixCurrentMinute:row];
        NSInteger index = [self.types indexOfObject:@(RGTimePickerTypeSecond)];
        if (index != NSNotFound) {
            [self fixCurrentSecondInComponent:index picker:pickerView];
        }
    }
    if (type == RGTimePickerTypeSecond) {
        row *= self.steps[0].intValue;
        [self fixCurrentSecond:row];
    }
    
    if (RGTimePickerChange) {
        RGTimePickerChange(self, self.currentTime);
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    [super selectRow:row inComponent:component animated:animated];
    RGTimePickerType type = [self.types[component] unsignedIntegerValue];
    switch (type) {
        case RGTimePickerTypeHour:
            [self fixCurrentHourInComponent:component picker:self];
            break;
        case RGTimePickerTypeMinute:
            [self fixCurrentMinuteInComponent:component picker:self];
            break;
        case RGTimePickerTypeSecond:
            [self fixCurrentSecondInComponent:component picker:self];
            break;
        default:
            break;
    }
}

- (void)fixCurrentHour:(NSInteger)hour {
    self.currentHour = hour;
}

- (void)fixCurrentMinute:(NSInteger)minute {
    if (self.currentHour == self.minHour) {
        self.currentMinute = minute + self.minMinute;
    } else {
        self.currentMinute = minute;
    }
}

- (void)fixCurrentSecond:(NSInteger)second {
    if (self.currentMinute == self.minMinute && self.currentHour == self.minHour) {
        self.currentSecond = second + self.minSecond;
    } else {
        self.currentSecond = second;
    }
}

- (void)fixCurrentHourInComponent:(NSInteger)component picker:(UIPickerView *)picker {
    [picker reloadComponent:component];
    NSUInteger num = [picker numberOfRowsInComponent:component];
    NSUInteger row = [picker selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[0].intValue;
    [self fixCurrentHour:row];
}

- (void)fixCurrentMinuteInComponent:(NSInteger)component picker:(UIPickerView *)picker {
    [picker reloadComponent:component];
    NSUInteger num = [picker numberOfRowsInComponent:component];
    NSUInteger row = [picker selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[1].intValue;
    [self fixCurrentMinute:row];
}

- (void)fixCurrentSecondInComponent:(NSInteger)component picker:(UIPickerView *)picker {
    [picker reloadComponent:component];
    NSUInteger num = [picker numberOfRowsInComponent:component];
    NSUInteger row = [picker selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[0].intValue;
    [self fixCurrentSecond:row];
}

@end
