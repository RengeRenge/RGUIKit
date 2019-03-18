//
//  RGTimePicker.m
//  RGTimePicker
//
//  Created by renge on 2018/10/18.
//  Copyright © 2018年 ld. All rights reserved.
//

#import "RGTimePicker.h"

NSInteger RGTimePickerDayTimeInterval = 24 * 60 * 60;

#define _RGTimePickerDayTimeInterval (RGTimePickerDayTimeInterval - (_nextDay ? 0 : 1))

static UIWindow *RGTimePickerWindow = nil;
static RGTimePicker *RGTimePickerShared = nil;
static UIToolbar *RGTimePickerToolBarShared = nil;

static void(^RGTimePickerCommit)(NSInteger);
static void(^RGTimePickerCancel)(void);

@interface RGTimePicker ()

@property (nonatomic, assign) NSInteger minMinute;
@property (nonatomic, assign) NSInteger minHour;

@property (nonatomic, assign) NSInteger maxMinute;
@property (nonatomic, assign) NSInteger maxHour;

@property (nonatomic, assign) NSInteger currentHour;
@property (nonatomic, assign) NSInteger currentMinute;

@end

@implementation RGTimePicker

#pragma mark - Window

+ (void)showWithTitle:(NSString *)title defaultTime:(NSInteger)defaultTime nextDay:(BOOL)nextDay minTime:(NSInteger)minTime maxTime:(NSInteger)maxTime commit:(void (^)(NSInteger))commit cancel:(void (^)(void))cancel {
    
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
        RGTimePickerShared = [[RGTimePicker alloc] initWithFrame:bounds];
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
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    titleItem.enabled = NO;
    
    UIBarButtonItem *fix1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    RGTimePickerToolBarShared.items = @[cancelItem, fix1, titleItem, fix2, okItem];
    
    RGTimePickerShared.nextDay = nextDay;
    RGTimePickerShared.minTime = minTime;
    RGTimePickerShared.maxTime = maxTime;
    RGTimePickerShared.currentTime = defaultTime;
    
    RGTimePickerCommit = commit;
    RGTimePickerCancel = cancel;
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
    
    void(^RGTimePickerBlockTemp)(NSInteger) = RGTimePickerCommit;
    RGTimePickerCommit = nil;
    RGTimePickerCancel = nil;
    
    NSInteger time = RGTimePickerShared.currentTime;
    
    [self dismiss:^{
        if (RGTimePickerBlockTemp) {
            RGTimePickerBlockTemp(MIN(time, RGTimePickerDayTimeInterval));
        }
    }];
}

+ (void)cancel {
    
    void(^RGTimePickerBlockTemp)(void) = RGTimePickerCancel;
    RGTimePickerCommit = nil;
    RGTimePickerCancel = nil;
    
    [self dismiss:^{
        if (RGTimePickerBlockTemp) {
            RGTimePickerBlockTemp();
        }
    }];
}

#pragma mark - TimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)setNextDay:(BOOL)nextDay {
    _nextDay = nextDay;
}

- (void)setMinTime:(NSInteger)minTime {
    
    _minTime = MIN(minTime, _RGTimePickerDayTimeInterval);
    
    self.minHour = _minTime / 3600;
    self.minMinute = (_minTime - self.minHour * 3600) / 60;
    
    if (_currentTime < _minTime) {
        self.currentTime = _minTime;
    } else {
        [self reloadAllComponents];
    }
}

- (void)setMaxTime:(NSInteger)maxTime {
    
    _maxTime = MIN(maxTime, _RGTimePickerDayTimeInterval);
    
    self.maxHour = _maxTime / 3600;
    self.maxMinute = (_maxTime - self.maxHour * 3600) / 60;
    
    [self reloadAllComponents];
}

- (void)setCurrentTime:(NSInteger)currentTime {
    if (currentTime < self.minTime) {
        return;
    }
    currentTime = MIN(currentTime, _RGTimePickerDayTimeInterval);
    self.currentHour = currentTime / 3600;
    self.currentMinute = (currentTime - self.currentHour * 3600) / 60;
    [self reloadAllComponents];
    
    [self selectRow:MAX(0, _currentHour - _minHour) inComponent:0 animated:YES];
    if (_currentHour == _minHour) {
        [self selectRow:MAX(0, _currentMinute - _minMinute) inComponent:1 animated:YES];
    } else {
        [self selectRow:_currentMinute inComponent:1 animated:YES];
    }
}

- (void)setCurrentHour:(NSInteger)currentHour {
    _currentHour = MIN(24, MAX(0, currentHour));
    _currentTime = (_currentHour * 60 + _currentMinute) * 60;
}

- (void)setCurrentMinute:(NSInteger)currentMinute {
    _currentMinute = MIN(59, MAX(0, currentMinute));
    _currentTime = (_currentHour * 60 + _currentMinute) * 60;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.maxHour - self.minHour + 1;
    }
    
    NSInteger number = 60;
    if (self.currentHour == self.maxHour) {
        number = (self.maxMinute + 1);
    }
    
    if (self.currentHour == self.minHour) {
        number -= self.minMinute;
    }
    
    return number;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%02ld", self.minHour + row];
    }
    if (component == 1) {
        if (self.currentHour == self.minHour) {
            return [NSString stringWithFormat:@"%02ld", row + self.minMinute];
        }
    }
    return [NSString stringWithFormat:@"%02ld", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.currentHour = self.minHour + row;
        [pickerView reloadComponent:1];
        [self fixCurrentMinuteWithRow:[pickerView selectedRowInComponent:1]];
    }
    if (component == 1) {
        [self fixCurrentMinuteWithRow:row];
    }
}

- (void)fixCurrentMinuteWithRow:(NSInteger)row {
    if (self.currentHour == self.minHour) {
        self.currentMinute = row + self.minMinute;
    } else {
        self.currentMinute = row;
    }
}

@end
