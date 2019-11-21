//
//  RGToastView.m
//  RGUIKit
//
//  Created by renge on 2019/11/26.
//

#import "RGToastView.h"
#import <RGUIKit/RGUIKit.h>

static UIWindow *_rg_toastView_window = nil;
static RGToastView *_rg_toastView = nil;

@interface RGToastView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGFloat percentY;

@property (nonatomic, assign) NSInteger cTag;

@end

@implementation RGToastView

+ (UIWindow *)frontWindow:(UIWindowLevel)maxSupportedWindowLevel {
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= maxSupportedWindowLevel);
        BOOL windowKeyWindow = window.isKeyWindow;
            
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
#endif
    return nil;
}

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY {
//    if (!_rg_toastView_window) {
//        _rg_toastView_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [_rg_toastView_window setWindowLevel:UIWindowLevelAlert];
//        _rg_toastView_window.userInteractionEnabled = NO;
//    }
    UIWindow *window = [self frontWindow:UIWindowLevelNormal];
    
//    if (!window.rootViewController) {
//        UIViewController *vc = [[UIViewController alloc] init];
//        window.rootViewController = vc;
//    }
    
    if (!_rg_toastView) {
//        _rg_toastView = [[self.class alloc] initWithFrame:window.rootViewController.view.bounds];
        _rg_toastView = [[self.class alloc] initWithFrame:window.bounds];
        _rg_toastView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        window.rootViewController.view.userInteractionEnabled = NO;
//        [window.rootViewController.view addSubview:_rg_toastView];
        [window addSubview:_rg_toastView];
    }
    
    RGToastView *toast = _rg_toastView;
    
    toast.cTag = arc4random();
    toast.percentY = percentY;
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 10.f;
    para.alignment = NSTextAlignmentCenter;
    toast.label.attributedText = [[NSAttributedString alloc] initWithString:info attributes:@{NSParagraphStyleAttributeName : para}];
    [toast setNeedsLayout];
    
//    window.hidden = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [toast showAnimateWithCompletion:^(BOOL finished) {
        if (duration) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
        }
    }];
}

+ (void)dismiss {
    [_rg_toastView dismissAnimateWithCompletion:^(BOOL finished) {
        if (finished) {
            _rg_toastView_window.hidden = YES;
            _rg_toastView_window.rootViewController = nil;
            [_rg_toastView removeFromSuperview];
            _rg_toastView = nil;
        }
    }];
}

- (void)dismiss {
    [self dismissAnimateWithCompletion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (RGToastView *)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY inView:(UIView *)view {
    RGToastView *toast = [[RGToastView alloc] initWithFrame:view.bounds];;
    toast.label.text = info;
    toast.percentY = percentY;
    
    toast.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view addSubview:toast];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:toast selector:@selector(dismiss) object:nil];
    [toast showAnimateWithCompletion:^(BOOL finished) {
        if (duration) {
            [toast performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
        }
    }];
    return toast;
}

- (void)dismissAnimateWithCompletion:(void(^)(BOOL finished))completion {
    NSInteger cTag = self.cTag;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.cTag == cTag) {
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}

- (void)showAnimateWithCompletion:(void(^)(BOOL finished))completion {
    if (self.alpha != 0) {
        if (completion) {
            completion(YES);
        }
        return;
    }
    self.alpha = 0;
    NSInteger cTag = self.cTag;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.cTag == cTag) {
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.alpha = 0;
        [self addSubview:self.backgroundView];
        [self addSubview:self.label];
    }
    return self;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColor.darkTextColor;
        _backgroundView.layer.cornerRadius = 10;
        _backgroundView.layer.masksToBounds = YES;
    }
    return _backgroundView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = UIColor.lightTextColor;
        _label.font = [UIFont systemFontOfSize:12.f];
        _label.numberOfLines = 0;
    }
    return _label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.superview) {
        return;
    }
    CGRect bounds = self.superview.bounds;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        insets = self.safeAreaInsets;
    }
    insets.left += 40;
    insets.right += 40;
    
    CGRect frame = UIEdgeInsetsInsetRect(bounds, insets);
    CGSize size = [self.label sizeThatFits:frame.size];
    
    frame.origin.y = insets.top + frame.size.height * self.percentY - size.height;
    frame.origin.y = MIN(CGRectGetMaxY(bounds) - size.height - 20, MAX(20, frame.origin.y));
    frame.origin.x = (CGRectGetMaxX(bounds) - size.width) / 2.f;
    frame.size = size;
    self.label.frame = frame;
    self.backgroundView.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-10, -15, -10, -15));
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    [self setNeedsLayout];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

@end
