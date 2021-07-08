//
//  UINavigationBar+RGAlpha.m
//  RGUIKit
//
//  Created by renge on 2021/7/7.
//

#import "UINavigationBar+RGAlpha.h"
#import <RGRunTime/RGRunTime.h>
#import <RGObserver/RGObserver.h>

static char *UINavigationBarRGAlphaKey = "UINavigationBarRGAlphaKey";
static char *UINavigationBarRGAlphaSettingKey = "UINavigationBarRGAlphaSettingKey";

@implementation UINavigationBar(RGAlpha)

- (void)setRg_backgroundAlpha:(CGFloat)rg_alpha {
    [self rg_setValue:@(rg_alpha) forConstKey:UINavigationBarRGAlphaKey retain:YES];
    
    [self rg_setValue:@YES forConstKey:UINavigationBarRGAlphaSettingKey retain:YES];
    [self __setNavigationBackgroundAlpha:rg_alpha view:self];
    [self rg_setValue:@NO forConstKey:UINavigationBarRGAlphaSettingKey retain:YES];
}

- (CGFloat)rg_backgroundAlpha {
    NSNumber *a = [self rg_valueforConstKey:UINavigationBarRGAlphaKey];
    if (a) {
        return [a floatValue];
    }
    return 1.0;
}

- (void)__setNavigationBackgroundAlpha:(CGFloat)alpha view:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *className = NSStringFromClass(obj.class);
        if (self.isTranslucent && ([obj isKindOfClass:UIImageView.class] || [obj isKindOfClass:UIVisualEffectView.class])) {
            obj.alpha = alpha;
            [obj rg_addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
        } else if (!self.isTranslucent && [className containsString:@"Background"]) {
            obj.alpha = alpha;
            [obj rg_addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
        } else {
            if ([className containsString:@"ButtonBarButton"]) {
                return;
            }
            [self __setNavigationBackgroundAlpha:alpha view:obj];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![[self rg_valueforConstKey:UINavigationBarRGAlphaSettingKey] boolValue] && [keyPath isEqualToString:@"alpha"]) {
        if ([object alpha] != self.rg_backgroundAlpha) {
            [self _setttingAlpha];
        }
    }
}

- (void)_setttingAlpha {
    self.rg_backgroundAlpha = self.rg_backgroundAlpha;
}

@end
