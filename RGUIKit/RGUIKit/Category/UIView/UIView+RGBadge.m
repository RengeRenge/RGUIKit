//
//  UIView+RGBadge.m
//  RGUIKit
//
//  Created by renge on 2021/8/2.
//

#import "UIView+RGBadge.h"
#import "UIImage+RGTint.h"
#import "UIView+RGLayoutHelp.h"

#import <RGObserver/RGObserver.h>
#import <RGRunTime/RGRunTime.h>

#define kUITabbarCustomNormalBadgeHeight 10
#define kUITabbarCustomWarningBadgeHeight 18

char *rg_badgeViewKey = "rg_badgeView";
char *rg_badgePositionKey = "rg_badgePosition";
char *rg_badgeHorizontalMarginKey = "rg_badgeHorizontalMargin";
char *rg_badgeVerticalMarginKey = "rg_badgeVerticalMargin";

@interface RGBadgeView : UIButton

@end

@implementation RGBadgeView

@end

@implementation UIView(RGBadge)

- (UIButton *)rg_badgeView {
    return [self rg_valueforConstKey:rg_badgeViewKey];
}

- (void)setRg_badgeView:(UIButton *)rg_badgeView {
    [self rg_setValue:rg_badgeView forConstKey:rg_badgeViewKey retain:YES];
}

- (UIButton *)createBadgeViewIfNeed {
    UIButton *badgeView = self.rg_badgeView;
    if (!badgeView) {
        badgeView = [[RGBadgeView alloc] init];
        badgeView.userInteractionEnabled = NO;
        badgeView.layer.masksToBounds = YES;
        badgeView.tintColor = [UIColor redColor];
        badgeView.titleLabel.textAlignment = NSTextAlignmentCenter;
        badgeView.titleLabel.font = [UIFont systemFontOfSize:13];
        badgeView.adjustsImageWhenHighlighted = NO;
        badgeView.clipsToBounds = YES;
        self.rg_badgeView = badgeView;
    }
    return badgeView;
}

- (RGUIViewBadgePosition)rg_badgePosition {
    return [[self rg_valueforConstKey:rg_badgePositionKey] integerValue];
}

- (void)setRg_badgePosition:(RGUIViewBadgePosition)rg_badgePosition {
    [self rg_setValue:@(rg_badgePosition) forConstKey:rg_badgePositionKey retain:YES];
    [self __rg_addBadgeView:self.rg_badgeView];
}

- (CGFloat)rg_badgeHorizontalMargin {
    return [[self rg_valueforConstKey:rg_badgeHorizontalMarginKey] floatValue];
}

- (void)setRg_badgeHorizontalMargin:(CGFloat)rg_badgeHorizontalMargin {
    [self rg_setValue:@(rg_badgeHorizontalMargin) forConstKey:rg_badgeHorizontalMarginKey retain:YES];
    [self __rg_addBadgeView:self.rg_badgeView];
}

- (CGFloat)rg_badgeVerticalMargin {
    return [[self rg_valueforConstKey:rg_badgeVerticalMarginKey] floatValue];
}

- (void)setRg_badgeVerticalMargin:(CGFloat)rg_badgeVerticalMargin {
    [self rg_setValue:@(rg_badgeVerticalMargin) forConstKey:rg_badgeVerticalMarginKey retain:YES];
    [self __rg_addBadgeView:self.rg_badgeView];
}

- (void)rg_showBadgeWithType:(RGUIViewBadgeType)type {
    switch (type) {
        case RGUIViewBadgeTypeNormal:
            break;
        case RGUIViewBadgeTypeValue:
            return;
        default:
            [self __rg_removeBadgeView];
            return;
    }
    
    CGFloat height = kUITabbarCustomNormalBadgeHeight;
    UIButton *badgeView = self.createBadgeViewIfNeed;
    badgeView.frame = CGRectMake(0, 0, height, height);
    badgeView.layer.cornerRadius = height / 2;
    
    [badgeView setTitle:nil forState:UIControlStateNormal];
    [badgeView setBackgroundImage:[UIImage rg_templateImageWithSize:CGSizeMake(2, 2)] forState:UIControlStateNormal];
    
    [self __rg_addBadgeView:badgeView];
}

- (void)rg_showBadgeWithValue:(NSString *)value {
    if (!value) {
        [self __rg_removeBadgeView];
        return;
    }
    
    CGFloat height = kUITabbarCustomWarningBadgeHeight;
    CGFloat width = kUITabbarCustomWarningBadgeHeight;
    UIButton *badgeView = self.createBadgeViewIfNeed;
    
    [badgeView setTitle:value forState:UIControlStateNormal];
    [badgeView setBackgroundImage:[UIImage rg_templateImageWithSize:CGSizeMake(2, 2)] forState:UIControlStateNormal];
    [badgeView sizeToFit];
    
    width = MAX(CGRectGetWidth(badgeView.frame) + 10, width);
    badgeView.frame = CGRectMake(0, 0, width, height);
    
    badgeView.layer.cornerRadius = height / 2;
    
    [self __rg_addBadgeView:badgeView];
}

- (void)__rg_addBadgeView:(UIButton *)badgeView {
    BOOL layoutLeftToRight = self.rg_layoutLeftToRight;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = badgeView.frame.size.width;
    CGFloat height = badgeView.frame.size.height;
    CGFloat hMargin = self.rg_badgeHorizontalMargin;
    CGFloat vMargin = self.rg_badgeVerticalMargin;
    RGUIViewBadgePosition position = self.rg_badgePosition;
    
    if (position & RGUIViewBadgeHorizontalTrailingOutFull) {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame);
        } else {
            x = - width;
        }
    } else if (position & RGUIViewBadgeHorizontalTrailingOutHalf) {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame) - width / 2.f;
        } else {
            x = - width / 2.f;
        }
    } else {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame) - width;
        } else {
            x = 0;
        }
    }
    if (layoutLeftToRight) {
        x -= hMargin;
    } else {
        x += hMargin;
    }
    
    if (position & RGUIViewBadgeVerticalTopOutFull) {
        y = - height;
    } else if (position & RGUIViewBadgeVerticalTopOutHalf) {
        y = - height / 2.f;
    } else if (position & RGUIViewBadgeVerticalCenter) {
        y = (CGRectGetHeight(self.frame) - height) / 2.f;
    }
    y += vMargin;

    badgeView.frame = CGRectMake(x, y, width, height);
    
    UIViewAutoresizing resize = UIViewAutoresizingFlexibleBottomMargin;
    if (position & RGUIViewBadgeVerticalCenter) {
        resize |= UIViewAutoresizingFlexibleBottomMargin;
    }
    if (layoutLeftToRight) {
        resize |= UIViewAutoresizingFlexibleLeftMargin;
    } else {
        resize |= UIViewAutoresizingFlexibleRightMargin;
    }
    
    badgeView.autoresizingMask = resize;
    if (badgeView.superview != self) {
        [self addSubview:badgeView];
    }
    
    [self rg_addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:rg_badgePositionKey];
    [self rg_addObserver:self forKeyPath:@"semanticContentAttribute" options:NSKeyValueObservingOptionNew context:rg_badgePositionKey];
}

- (void)__rg_removeBadgeView {
    [self rg_removeObserver:self forKeyPath:@"frame"];
    [self rg_removeObserver:self forKeyPath:@"semanticContentAttribute"];
    [self.rg_badgeView removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self &&
        context == rg_badgePositionKey &&
        ([keyPath isEqualToString:@"frame"] ||
         [keyPath isEqualToString:@"semanticContentAttribute"])
        ) {
        if (self.rg_badgeView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __rg_addBadgeView:self.rg_badgeView];
            });
        }
    }
}

@end

@interface RGBadgeOB : NSObject

@end

RGBadgeOB *__barButtonItemBadgeOB;
NSString *__rg_viewCallbackKey = @"__rg_viewCallbackKey";

@implementation UIBarButtonItem(RGBadge)

- (NSMutableArray <void(^)(UIView *)> *)__callbacks {
    return [self rg_valueForKey:__rg_viewCallbackKey];
}

- (void)__createCallbacks {
    NSMutableArray *callbacks = [self __callbacks];
    if (!callbacks) {
        callbacks = NSMutableArray.new;
        [self rg_setValue:callbacks forKey:__rg_viewCallbackKey retain:YES];
    }
}

- (void)__releaseCallbacks {
    [self rg_setValue:nil forKey:__rg_viewCallbackKey retain:YES];
}

- (UIView *)__rg_view {
    UIView *navigationButton = [self valueForKey:@"_view"];
//    double systemVersion = [UIDevice currentDevice].systemVersion.doubleValue;
//    NSString *controlName = (systemVersion < 11 ? @"UIImageView" : @"UIButton" );
//    for (UIView *subView in navigationButton.subviews) {
//        if ([subView isKindOfClass:NSClassFromString(controlName)] && ![subView isKindOfClass:RGBadgeView.class]) {
//            return subView;
//        }
//    }
    return navigationButton;
}

- (void)rg_getView:(void (^)(UIView * _Nonnull))result {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __barButtonItemBadgeOB = RGBadgeOB.new;
    });
    
    UIView *view = [self __rg_view];
    if (view) {
        result(view);
        return;
    }
    [self __createCallbacks];
    [self.__callbacks addObject:result];
    [self rg_addObserver:__barButtonItemBadgeOB forKeyPath:@"view" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(__rg_viewCallbackKey)];
}

@end


@implementation RGBadgeOB

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"view"] &&
        [object isKindOfClass:UIBarButtonItem.class] &&
        context == (__bridge void * _Nullable)(__rg_viewCallbackKey)) {
        UIView *view = [object __rg_view];
        if (view) {
            NSMutableArray <void(^)(UIView *)> *callbacks = [object __callbacks];
            
            [object rg_removeObserver:self forKeyPath:@"view"];
            [object __releaseCallbacks];
            
            [callbacks enumerateObjectsUsingBlock:^(void (^_Nonnull obj)(UIView *), NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    obj(view);
                }
            }];
        }
    }
}

@end
