//
//  RGToastView.m
//  RGUIKit
//
//  Created by renge on 2019/11/26.
//

#import "RGToastView.h"
#import <RGUIKit/RGUIKit.h>

static RGToastView *_rg_toastView = nil;
static NSString *rg_toast_createKey = @"rg_toast_key";

@interface RGToastView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGFloat percentY;

@property (nonatomic, assign) NSInteger cTag;

@end

@implementation RGToastView

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY {
    RGWindow *window = [RGWindow findWindowWithCreateKey:rg_toast_createKey];
    RGToastView *toast = nil;
    if (!window) {
        window = [RGWindow windowWithCreateKey:rg_toast_createKey];
        RGToastView *toast = [[self.class alloc] initWithFrame:window.bounds];
        toast.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [window showWithAddtionView:toast animation:nil completion:nil];
    }
    
    toast = (RGToastView *)window.addtionView;
    [toast configWithInfo:info percentY:percentY];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:toast selector:@selector(dismiss) object:nil];
    [toast showAnimateWithCompletion:^(BOOL finished) {
        if (duration) {
            [toast performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
        }
    }];
}

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY viewController:(UIViewController *)viewController {
    if (@available(iOS 13.0, *)) {
        UIScene *scene = viewController.rg_scene;
        if (scene) {
            [self showWithInfo:info duration:duration percentY:percentY scene:scene];
            return;
        }
    }
    [self showWithInfo:info duration:duration percentY:percentY];
}

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY scene:(UIScene *)scene {
    RGWindow *window = [RGWindow findWindowWithScene:scene createKey:rg_toast_createKey];
    if (!window) {
        window = [RGWindow windowWithScene:scene createKey:rg_toast_createKey];
        RGToastView *toast = [[self.class alloc] initWithFrame:window.bounds];
        toast.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [window showWithAddtionView:toast animation:nil completion:nil];
    }
    
    RGToastView *toast = (RGToastView *)window.addtionView;
    [toast configWithInfo:info percentY:percentY];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissWithScene:) object:scene];
    [toast showAnimateWithCompletion:^(BOOL finished) {
        if (duration) {
            [self performSelector:@selector(dismissWithScene:) withObject:scene afterDelay:duration];
        }
    }];
}

- (void)configWithInfo:(NSString *)info percentY:(CGFloat)percentY {
    self.cTag = arc4random();
    self.percentY = percentY;
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 10.f;
    para.alignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.label.attributedText = [[NSAttributedString alloc] initWithString:info attributes:@{NSParagraphStyleAttributeName : para}];
    [self setNeedsLayout];
}

+ (void)dismiss {
    RGWindow *window = [RGWindow findWindowWithCreateKey:rg_toast_createKey];
    RGToastView *toast = (RGToastView *)window.addtionView;
    [toast dismissAnimateWithCompletion:^(BOOL finished) {
        if (finished) {
            [window dismiss];
        }
    }];
}

+ (void)dismissWithViewController:(UIViewController *)viewController {
    RGWindow *window = [RGWindow findWindowWithViewController:viewController createKey:rg_toast_createKey];
    RGToastView *toast = (RGToastView *)window.addtionView;
    [toast dismissAnimateWithCompletion:^(BOOL finished) {
        if (finished) {
            [window dismiss];
        }
    }];
}

+ (void)dismissWithScene:(UIScene *)scene  API_AVAILABLE(ios(13.0)) {
    RGWindow *window = [RGWindow findWindowWithScene:scene createKey:rg_toast_createKey];
    RGToastView *toast = (RGToastView *)window.addtionView;
    [toast dismissAnimateWithCompletion:^(BOOL finished) {
        if (finished) {
            [window dismiss];
        }
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

- (void)dismiss {
    RGWindow *window = (RGWindow *)[self window];
    [self dismissAnimateWithCompletion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            if ([window isKindOfClass:RGWindow.class]) {
                [window dismiss];
            }
        }
    }];
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
