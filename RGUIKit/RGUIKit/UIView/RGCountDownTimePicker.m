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
#define _RGTimePickerDayTimeInterval ((self.pickerType & RGCountDownTimePickerTypeHours) ? RGTimePickerDayTimeInterval : ((self.pickerType & RGCountDownTimePickerTypeMin) ? 60*60 : 60))

static UIWindow *RGTimePickerWindow = nil;
static RGCountDownTimePicker *RGTimePickerShared = nil;
static UIView *RGTimePickerWrapperShared = nil;
static UIToolbar *RGTimePickerToolBarShared = nil;
static void(^RGTimePickerCommit)(RGCountDownTimePicker *, NSInteger);
static void(^RGTimePickerCancel)(RGCountDownTimePicker *);

static CGFloat RGCountDownTimePickerRowWidthAddtion = 10;
@interface RGCountDownTimePicker ()

@property (nonatomic, strong) NSArray <NSNumber *> *minimum;
@property (nonatomic, strong) NSArray <NSNumber *> *maximum;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *current;

@property (nonatomic, strong) NSArray <NSNumber *> *steps;

@property (nonatomic, strong) NSArray <NSNumber *> *types;
@property (nonatomic, strong) NSArray <UILabel *> *typeUnits;

@property (nonatomic, strong) UIFont *rowLabelFont;
@property (nonatomic, assign) CGFloat space;

@property (nonatomic, copy) NSString *splitString;
@property (nonatomic, assign) BOOL splitMode;

@end

@implementation RGCountDownTimePicker
@synthesize currentTime = _currentTime;

#pragma mark - Window


+ (UIWindowScene *)rg_firstActiveWindowScene  API_AVAILABLE(ios(13.0)) {
    NSEnumerator *scenes = [UIApplication.sharedApplication.connectedScenes.allObjects objectEnumerator];
    for (UIScene *scene in scenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:UIWindowScene.class] &&
            [scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]
            ) {
            return (UIWindowScene *)scene;
        }
    }
    return nil;
}


+ (void)showWithDefaultTime:(NSInteger)defaultTime
                      title:(NSString *)title
                commitTitle:(NSString *)commitTitle
                cancelTitle:(NSString *)cancelTitle
                     config:(nonnull void (^)(RGCountDownTimePicker * _Nonnull))config
                     change:(nullable void (^)(RGCountDownTimePicker * _Nonnull, NSInteger))change
                     commit:(nullable void (^)(RGCountDownTimePicker * _Nonnull, NSInteger))commit
                     cancel:(nullable void (^)(RGCountDownTimePicker * _Nonnull))cancel {
    if (!RGTimePickerWindow) {
        if (@available(iOS 13.0, *)) {
            RGTimePickerWindow = [[UIWindow alloc] initWithWindowScene:[self rg_firstActiveWindowScene]];
        } else {
            RGTimePickerWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
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
        
        UIViewAutoresizing autoresizing = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        UIView *wrapper = [[UIView alloc] initWithFrame:bounds];
        wrapper.autoresizingMask = autoresizing;
        if (@available(iOS 13.0, *)) {
            wrapper.backgroundColor = UIColor.secondarySystemBackgroundColor;
        } else {
            wrapper.backgroundColor = UIColor.whiteColor;
        }
        
        UIVisualEffectView *effectWrapper = [[UIVisualEffectView alloc] initWithFrame:wrapper.bounds];
        if (@available(iOS 10.0, *)) {
            effectWrapper.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        } else {
            effectWrapper.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        }
        effectWrapper.autoresizingMask = autoresizing;
        
        // picker
        bounds = UIEdgeInsetsInsetRect(wrapper.bounds, UIEdgeInsetsMake(40, 0, 0, 0));
        RGTimePickerShared = [[RGCountDownTimePicker alloc] initWithFrame:bounds];
        RGTimePickerShared.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        // tool
        bounds = UIEdgeInsetsInsetRect(wrapper.bounds, UIEdgeInsetsMake(40, 0, 0, 0));
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 40)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        toolbar.translucent = YES;
        
        [window.rootViewController.view addSubview:wrapper];
        [wrapper addSubview:effectWrapper];
        [effectWrapper.contentView addSubview:RGTimePickerShared];
        [effectWrapper.contentView addSubview:toolbar];
        
        RGTimePickerToolBarShared = toolbar;
        RGTimePickerWrapperShared = wrapper;
        
        bgView.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect bounds = window.rootViewController.view.bounds;
            bounds.origin.y = bounds.size.height - height;
            bounds.size.height = height;
            wrapper.frame = bounds;
            
            bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
        }];
    }
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:commitTitle style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    titleItem.enabled = NO;
    
    UIBarButtonItem *fix1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    RGTimePickerToolBarShared.items = @[cancelItem, fix1, titleItem, fix2, okItem];
    
    RGTimePickerShared.step = 1;
    if (config) {
        config(RGTimePickerShared);
    }
    RGTimePickerShared.currentTime = defaultTime;
    
    RGTimePickerShared.change = change;
    RGTimePickerCommit = commit;
    RGTimePickerCancel = cancel;
    [RGTimePickerShared reloadAllComponents];
    window.hidden = NO;
}

+ (void)dismiss:(void(^)(void))completion {
    UIView *wapper = RGTimePickerWrapperShared;
    [UIView animateWithDuration:0.3 animations:^{
        wapper.frame = CGRectOffset(wapper.frame, 0, wapper.frame.size.height);
    } completion:^(BOOL finished) {
        
        RGTimePickerWindow.hidden = YES;
        RGTimePickerWindow.rootViewController = nil;
        [RGTimePickerShared removeFromSuperview];
        [RGTimePickerToolBarShared removeFromSuperview];
        RGTimePickerToolBarShared = nil;
        RGTimePickerShared = nil;
        RGTimePickerWrapperShared = nil;
        
        if (completion) {
            completion();
        }
    }];
}

+ (void)ok {
    
    void(^RGTimePickerBlockTemp)(RGCountDownTimePicker *, NSInteger) = RGTimePickerCommit;
    RGTimePickerShared.change = nil;
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
    RGTimePickerShared.change = nil;
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
        self.pickerType = RGCountDownTimePickerTypeHours|RGCountDownTimePickerTypeMin;
        [self.typeUnits enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.font = self.rowLabelFont;
            [self addSubview:obj];
        }];
        [self __setUnit:[self _unitTitleWithType:RGCountDownTimePickerTypeHours] forPickerType:RGCountDownTimePickerTypeHours];
        [self __setUnit:[self _unitTitleWithType:RGCountDownTimePickerTypeMin] forPickerType:RGCountDownTimePickerTypeMin];
        [self __setUnit:[self _unitTitleWithType:RGCountDownTimePickerTypeSec] forPickerType:RGCountDownTimePickerTypeSec];
    }
    return self;
}

- (NSString *)_unitTitleWithType:(RGCountDownTimePickerType)type {
    NSString *title = nil;
    switch (type) {
        case RGCountDownTimePickerTypeHours:
            title = @"hours";
            break;
        case RGCountDownTimePickerTypeMin:
            title = @"min";
            break;
        case RGCountDownTimePickerTypeSec:
            title = @"sec";
            break;
        default:
            title = @"";
            break;
    }
    return title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.types.count) {
        return;
    }
    CGFloat addtion = self.splitMode ? 0 : RGCountDownTimePickerRowWidthAddtion;
    
    __block CGFloat widthSum = self.space * (self.types.count - 1);
    [self.types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        widthSum += [self __widthForComponent:idx];
    }];
    
    __block CGFloat start = (self.bounds.size.width - widthSum) / 2.f - addtion;
    
    [self.types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = self.typeUnits[idx];
        start += [self __widthForComponent:idx];
        label.center = CGPointMake(
                                   start + (self.splitMode ? self.space / 2.f : -label.frame.size.width / 2.f),
                                   self.bounds.size.height / 2.f
                                   );
        start += self.space;
    }];
}

- (UIFont *)rowLabelFont {
    if (!_rowLabelFont) {
        _rowLabelFont = [UIFont systemFontOfSize:UIFont.labelFontSize];
    }
    return _rowLabelFont;
}

- (NSInteger)currentHour {
    return _current[0].integerValue;
}

- (void)setCurrentHour:(NSInteger)currentHour {
    _current[0] = @(MIN(24, MAX(0, currentHour)));
}

- (NSInteger)currentMinute {
    return _current[1].integerValue;
}

- (void)setCurrentMinute:(NSInteger)currentMinute {
    _current[1] = @(MIN(59, MAX(0, currentMinute)));
}

- (NSInteger)currentSecond {
    return _current[2].integerValue;
}

- (void)setCurrentSecond:(NSInteger)currentSecond {
    _current[2] = @(currentSecond);
}

- (NSInteger)minHour {
    return _minimum[0].integerValue;
}

- (NSInteger)minMinute {
    return _minimum[1].integerValue;
}

- (NSInteger)minSecond {
    return _minimum[2].integerValue;
}

- (NSInteger)maxHour {
    return _maximum[0].integerValue;
}

- (NSInteger)maxMinute {
    return _maximum[1].integerValue;
}

- (NSInteger)maxSecond {
    return _maximum[2].integerValue;
}

- (NSArray<UILabel *> *)typeUnits {
    if (!_typeUnits) {
        _typeUnits = @[UILabel.new, UILabel.new, UILabel.new];
    }
    return _typeUnits;
}

- (void)setMinimumTime:(NSInteger)minimumTime {
    _minimumTime = minimumTime;
    [self __commitConfig];
}

- (void)setStep:(NSInteger)step {
    _step = step;
    _steps = @[
        @(step < 60 ? step%60 : 1),
        @((step >= 60 && step < 3600) ? (step/60)%60 : 1),
        @((step >= 3600 ? (step/3600)%60 : 1))
    ];
    [self __commitConfig];
}

- (void)setMaximumTime:(NSInteger)maximumTime {
    _maximumTime = maximumTime;
    [self __commitConfig];
}

- (void)setCurrentTime:(NSInteger)currentTime {
    _currentTime = currentTime;
    [self __commitConfig];
}

- (void)setLabelColor:(UIColor *)labelColor {
    _labelColor = labelColor;
    [self.typeUnits enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = labelColor;
    }];
    [self reloadAllComponents];
}

- (void)setSpace:(CGFloat)space {
    if (_space == space) {
        return;
    }
    _space = space;
    [self setNeedsLayout];
}

- (void)setUnit:(NSString *)unit forPickerType:(RGCountDownTimePickerType)type {
    self.splitMode = NO;
    [self __setUnit:unit forPickerType:type];
    [self setNeedsLayout];
    [self reloadAllComponents];
}

- (void)setSplit:(NSString *)split forPickerType:(RGCountDownTimePickerType)type {
    self.splitString = split;
    self.splitMode = YES;
    NSMutableArray <NSNumber *> *types = [NSMutableArray array];
    if (type & RGCountDownTimePickerTypeHours) {
        [types addObject:@(RGCountDownTimePickerTypeHours)];
    }
    if (type & RGCountDownTimePickerTypeMin) {
        [types addObject:@(RGCountDownTimePickerTypeMin)];
    }
    if (type & RGCountDownTimePickerTypeSec) {
        [types addObject:@(RGCountDownTimePickerTypeSec)];
    }
    [types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx + 1 < types.count) {
            [self __setUnit:split forPickerType:obj.integerValue];
        } else {
            [self __setUnit:@" " forPickerType:obj.integerValue];
        }
    }];
    [self setNeedsLayout];
    [self reloadAllComponents];
}

- (void)__setUnit:(NSString *)unit forPickerType:(RGCountDownTimePickerType)type {
    NSUInteger index = 0;
    switch (type) {
        case RGCountDownTimePickerTypeHours:
            index = 0;
            break;
        case RGCountDownTimePickerTypeMin:
            index = 1;
            break;
        case RGCountDownTimePickerTypeSec:
            index = 2;
            break;
    }
    self.typeUnits[index].text = unit;
    self.typeUnits[index].textAlignment = NSTextAlignmentCenter;
    [self.typeUnits[index] sizeToFit];
    self.typeUnits[index].frame = UIEdgeInsetsInsetRect(self.typeUnits[index].frame, UIEdgeInsetsMake(0, -5, 0, -5));
}

- (NSInteger)currentTime {
    __block NSInteger time = 0;
    [self.types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RGCountDownTimePickerType type = obj.unsignedIntegerValue;
        switch (type) {
            case RGCountDownTimePickerTypeHours:
                time += _current[0].integerValue * 3600;
                break;
            case RGCountDownTimePickerTypeMin:
                time += _current[1].integerValue*60;
                break;
            case RGCountDownTimePickerTypeSec:
                time += _current[2].integerValue;
                break;
            default:
                break;
        }
    }];
    return time;
}

- (void)setPickerType:(RGCountDownTimePickerType)pickerType {
    _pickerType = pickerType;
    _types = nil;
    [self __commitConfig];
}

- (NSArray<NSNumber *> *)types {
    if (!_types) {
        NSMutableArray *array = [NSMutableArray array];
        if (_pickerType & RGCountDownTimePickerTypeHours) {
            [array addObject:@(RGCountDownTimePickerTypeHours)];
        }
        if (_pickerType & RGCountDownTimePickerTypeMin) {
            [array addObject:@(RGCountDownTimePickerTypeMin)];
        }
        if (_pickerType & RGCountDownTimePickerTypeSec) {
            [array addObject:@(RGCountDownTimePickerTypeSec)];
        }
        _types = array;
    }
    return _types;
}

- (void)__commitConfig {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(__doCommitConfig) object:nil];
    [self performSelector:@selector(__doCommitConfig) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes, NSDefaultRunLoopMode]];
}

- (void)__doCommitConfig {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(__doCommitConfig) object:nil];
    
    NSInteger minTime = MIN(self.minimumTime, _RGTimePickerDayTimeInterval);
    NSInteger maxTime = MIN(self.maximumTime, _RGTimePickerDayTimeInterval);
    
    NSInteger maxHour = maxTime / 3600;
    NSInteger maxMinute = (maxTime - maxHour * 3600) / 60;
    NSInteger maxSecond = maxTime % 60;
    
    NSInteger minHour = minTime / 3600;
    NSInteger minMinute = (minTime - minHour * 3600) / 60;
    NSInteger minSecond = minTime % 60;
    
    NSInteger currentTime = MAX(MIN(_currentTime, maxTime), minTime);
    
    NSInteger currentHour = currentTime / 3600;
    NSInteger currentMinute = (currentTime - currentHour * 3600) / 60;
    NSInteger currentSecond = currentTime % 60;
    
    self.minimum = @[@(minHour), @(minMinute), @(minSecond)];
    self.maximum = @[@(maxHour), @(maxMinute), @(maxSecond)];
    self.current = @[@(currentHour), @(currentMinute), @(currentSecond)].mutableCopy;
    
    [self reloadAllComponents];
    
    NSMutableArray <NSValue *> *array = [NSMutableArray array];
    [self.types enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *row = [self viewForRow:[self selectedRowInComponent:idx] forComponent:idx];
        NSValue *value = [NSValue valueWithCGRect:[row convertRect:row.bounds toView:self]];
        [array addObject:value];
    }];
    
    __block CGFloat space = 0;
    [array enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            space = CGRectGetMinX(obj.CGRectValue) - CGRectGetMaxX(array[idx - 1].CGRectValue);
        }
    }];
    self.space = space;
    
    if (currentTime < minTime) {
        [self __configCurrentTime];
    } else if (currentTime > maxTime) {
        [self __configCurrentTime];
    }
}

- (void)__configCurrentTime {
    NSInteger currentHour = self.currentHour;
    NSInteger currentSecond = self.currentSecond;
    NSInteger currentMinute = self.currentMinute;
    
    NSInteger minHour = self.minHour;
    NSInteger minMinute = self.minMinute;
    NSInteger minSecond = self.minSecond;
    
    NSUInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeHours)];
    if (index != NSNotFound) {
        [self selectRow:MAX(0, currentHour - minHour) / _steps[2].intValue inComponent:index animated:YES];
    }
    
    if (currentHour == minHour) {
        NSUInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeMin)];
        if (index != NSNotFound) {
            [self selectRow:MAX(0, currentMinute - minMinute) / _steps[1].intValue inComponent:index animated:YES];
        } else {
            
        }
    } else {
        NSUInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeMin)];
        if (index != NSNotFound) {
            [self selectRow:currentMinute / _steps[1].intValue inComponent:index animated:YES];
        }
    }
    
    if (currentMinute == minMinute) {
        NSUInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeSec)];
        if (index != NSNotFound) {
            [self selectRow:MAX(0, currentSecond - minSecond) / _steps[0].intValue inComponent:index animated:YES];
        }
    } else {
        NSUInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeSec)];
        if (index != NSNotFound) {
            [self selectRow:currentSecond / _steps[0].intValue inComponent:index animated:YES];
        }
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return self.types.count;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    RGCountDownTimePickerType type = [self.types[component] unsignedIntegerValue];
    if (type == 0) {
        return 1;
    }
    
    NSInteger number = 0;
    
    NSInteger start = 0;
    NSInteger end = 59;
    NSInteger step = 1;
    
    if (type == RGCountDownTimePickerTypeHours) {
        step = _steps[2].intValue;
        start = self.minHour;
        end = self.maxHour;
    }
    
    if (type == RGCountDownTimePickerTypeMin) {
        step = _steps[1].intValue;
        end = 59;
        if (self.currentHour == self.maxHour) {
            end = self.maxMinute;
        }
        if (self.currentHour == self.minHour) {
            start = self.minMinute;
        }
    }
    
    if (type == RGCountDownTimePickerTypeSec) {
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

- (NSString *)_titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    RGCountDownTimePickerType type = [self.types[component] unsignedIntegerValue];
    
    if (type == RGCountDownTimePickerTypeHours) {
        row *= self.steps[2].intValue;
        return [NSString stringWithFormat:@"%02ld", (long)self.minHour + row];
    }
    if (type == RGCountDownTimePickerTypeMin) {
        row *= self.steps[1].intValue;
        if (self.currentHour == self.minHour) {
            return [NSString stringWithFormat:@"%02ld", (long)row + self.minMinute];
        }
        return [NSString stringWithFormat:@"%02ld", (long)row];
    }
    if (type == RGCountDownTimePickerTypeSec) {
        row *= self.steps[0].intValue;
        if (self.currentMinute == self.minMinute && self.currentHour == self.minHour) {
            return [NSString stringWithFormat:@"%02ld", (long)row + self.minSecond];
        }
        return [NSString stringWithFormat:@"%02ld", (long)row];
    }
    return @"";
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self _titleForRow:row forComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.font = self.rowLabelFont;
    }
    label.textAlignment = self.splitMode ? NSTextAlignmentCenter : NSTextAlignmentNatural;
    label.text = [self _titleForRow:row forComponent:component];
    label.textColor = self.labelColor;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [self __widthForComponent:component];
}

- (CGFloat)__widthForComponent:(NSInteger)component {
    CGFloat rowWidth = [@"00" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading attributes:@{
        NSFontAttributeName: self.rowLabelFont
    } context:nil].size.width;
    CGFloat unitWith = 0;
    if (self.splitMode) {
        unitWith = [self.splitString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading attributes:@{
            NSFontAttributeName: self.rowLabelFont
        } context:nil].size.width;
    } else {
        unitWith = self.typeUnits[component].frame.size.width;
    }
    return rowWidth + unitWith + RGCountDownTimePickerRowWidthAddtion;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    RGCountDownTimePickerType type = [self.types[component] unsignedIntegerValue];
    
    if (type == RGCountDownTimePickerTypeHours) {
        row *= self.steps[2].intValue;
        self.currentHour = self.minHour + row;
        
        NSInteger minIndex = [self.types indexOfObject:@(RGCountDownTimePickerTypeMin)];
        if (minIndex != NSNotFound) {
            [self fixCurrentMinuteInComponent:minIndex];
        }
        
        NSInteger secIndex = [self.types indexOfObject:@(RGCountDownTimePickerTypeSec)];
        if (secIndex != NSNotFound) {
            [self fixCurrentSecondInComponent:secIndex];
        }
    }
    if (type == RGCountDownTimePickerTypeMin) {
        row *= self.steps[1].intValue;
        [self fixCurrentMinute:row];
        NSInteger index = [self.types indexOfObject:@(RGCountDownTimePickerTypeSec)];
        if (index != NSNotFound) {
            [self fixCurrentSecondInComponent:index];
        }
    }
    if (type == RGCountDownTimePickerTypeSec) {
        row *= self.steps[0].intValue;
        [self fixCurrentSecond:row];
    }
    
    if (_change) {
        _change(self, self.currentTime);
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    NSInteger count = 0;
    count = [super numberOfComponents];
    if (component >= count) {
        return;
    }
    count = [super numberOfRowsInComponent:component];
    if (row >= count) {
        return;
    }
    [super selectRow:row inComponent:component animated:animated];
    RGCountDownTimePickerType type = [self.types[component] unsignedIntegerValue];
    switch (type) {
        case RGCountDownTimePickerTypeHours:
            [self fixCurrentHourInComponent:component];
            break;
        case RGCountDownTimePickerTypeMin:
            [self fixCurrentMinuteInComponent:component];
            break;
        case RGCountDownTimePickerTypeSec:
            [self fixCurrentSecondInComponent:component];
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

- (void)fixCurrentHourInComponent:(NSInteger)component {
    [self reloadComponent:component];
    NSUInteger num = [self numberOfRowsInComponent:component];
    NSUInteger row = [self selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[0].intValue;
    [self fixCurrentHour:row];
}

- (void)fixCurrentMinuteInComponent:(NSInteger)component {
    [self reloadComponent:component];
    NSUInteger num = [self numberOfRowsInComponent:component];
    NSUInteger row = [self selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[1].intValue;
    [self fixCurrentMinute:row];
}

- (void)fixCurrentSecondInComponent:(NSInteger)component {
    [self reloadComponent:component];
    NSUInteger num = [self numberOfRowsInComponent:component];
    NSUInteger row = [self selectedRowInComponent:component];
    if (row > num - 1) {
        row = num - 1;
    }
    row *= self.steps[0].intValue;
    [self fixCurrentSecond:row];
}

@end
