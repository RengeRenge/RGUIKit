//
//  RGBlurEffect.m
//  RGUIKit
//
//  Created by renge on 2020/12/10.
//

#import "RGBlurEffect.h"

@interface UIBlurEffect (Protected)

@property (nonatomic, readonly) id effectSettings;

@end

@interface RGBlurEffect ()

@property (nonatomic, readonly) id effectSettingsRecord;

@end

@implementation RGBlurEffect

+ (RGBlurEffect *)effectWithStyle:(UIBlurEffectStyle)style {
    RGBlurEffect *effect = (RGBlurEffect *)[super effectWithStyle:style];
    effect.style = style;
    return effect;
}

+ (RGBlurEffect *)effectWithBlurRadius:(CGFloat)blurRadius {
    RGBlurEffect *effect = [self effectWithStyle:UIBlurEffectStyleLight];
    
    effect.blurRadius = blurRadius;
    effect.grayscaleTintLevel = 1;
    effect.grayscaleTintAlpha = 0;
    effect.saturationDeltaFactor = 1;
    
    return effect;
}

- (id)effectSettings {
    if (!_effectSettingsRecord) {
        _effectSettingsRecord = [super effectSettings];
    }
    return _effectSettingsRecord;
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    _blurRadius = blurRadius;
    [self setSettingsValue:@(blurRadius) forSelector:@selector(blurRadius)];
}

- (void)setGrayscaleTintLevel:(CGFloat)grayscaleTintLevel {
    _grayscaleTintLevel = grayscaleTintLevel;
    [self setSettingsValue:@(grayscaleTintLevel) forSelector:@selector(grayscaleTintLevel)];
}

- (void)setGrayscaleTintAlpha:(CGFloat)grayscaleTintAlpha {
    _grayscaleTintAlpha = grayscaleTintAlpha;
    [self setSettingsValue:@(grayscaleTintAlpha) forSelector:@selector(grayscaleTintAlpha)];
}

- (void)setSaturationDeltaFactor:(CGFloat)saturationDeltaFactor {
    _saturationDeltaFactor = saturationDeltaFactor;
    [self setSettingsValue:@(saturationDeltaFactor) forSelector:@selector(saturationDeltaFactor)];
}

// 避免审核风险
- (void)setSettingsValue:(id)value forSelector:(SEL)selector {
    [self.effectSettings setValue:value forKey:NSStringFromSelector(selector)];
}

- (id)settingsValueForSelector:(SEL)selector {
    return [self.effectSettings valueForKeyPath:NSStringFromSelector(selector)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.effectSettings];
}

@end

//    if (@available(iOS 10.0, *)) {
//        self.effect = nil;
//        __weak typeof(self) wSelf = self;
//        _ani = [[UIViewPropertyAnimator alloc] initWithDuration:1 curve:UIViewAnimationCurveLinear animations:^{
//            wSelf.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        }];
//        _ani.fractionComplete = [value floatValue] / RGBluuurViewMaxBlurRadius;
//        return;
//    }
