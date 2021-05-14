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

+ (RGBlurEffect *)effectWithStyle:(UIBlurEffectStyle)style blurRadius:(CGFloat)blurRadius {
    RGBlurEffect *effect = [self effectWithStyle:style];
    effect.blurRadius = blurRadius;
    return effect;
}

+ (RGBlurEffect *)effectWithBlurRadius:(CGFloat)blurRadius {
    RGBlurEffect *effect = [self effectWithStyle:UIBlurEffectStyleLight];
    effect.blurRadius = blurRadius;
    return effect;
}

+ (RGBlurEffect *)effectWithStyle:(UIBlurEffectStyle)style effect:(RGBlurEffect *)effect {
    if (!effect) {
        return [self effectWithStyle:style];
    }
    RGBlurEffect *eff = [self effectWithStyle:style];
    eff.blurRadius = effect.blurRadius;
    eff.grayscaleTintLevel = effect.grayscaleTintLevel;
    eff.grayscaleTintAlpha = effect.grayscaleTintAlpha;
    eff.saturationDeltaFactor = effect.saturationDeltaFactor;
    return eff;
}

- (void)configDark {
    self.grayscaleTintLevel = 0.11;
    self.grayscaleTintAlpha = 0.73;
    self.saturationDeltaFactor = 1.80;
}

- (void)configLight {
    self.grayscaleTintLevel = 1;
    self.grayscaleTintAlpha = 0.3;
    self.saturationDeltaFactor = 1.80;
    //    self.grayscaleTintLevel = 1;
    //    self.grayscaleTintAlpha = 0;
    //    self.saturationDeltaFactor = 1;
}

//- (id)copyWithZone:(NSZone *)zone {
//    return [self.class effectWithStyle:self.style effect:self];
//}

- (id)effectSettings {
    if (!_effectSettingsRecord) {
        _effectSettingsRecord = [super effectSettings];
    }
    return _effectSettingsRecord;
}

- (CGFloat)blurRadius {
    return [self getFloatSettingsSelector:@selector(blurRadius)];
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    [self setSettingsValue:@(blurRadius) forSelector:@selector(blurRadius)];
}

- (CGFloat)grayscaleTintLevel {
    return [self getFloatSettingsSelector:@selector(grayscaleTintLevel)];
}

- (void)setGrayscaleTintLevel:(CGFloat)grayscaleTintLevel {
    [self setSettingsValue:@(grayscaleTintLevel) forSelector:@selector(grayscaleTintLevel)];
}

- (CGFloat)grayscaleTintAlpha {
    return [self getFloatSettingsSelector:@selector(grayscaleTintAlpha)];
}

- (void)setGrayscaleTintAlpha:(CGFloat)grayscaleTintAlpha {
    [self setSettingsValue:@(grayscaleTintAlpha) forSelector:@selector(grayscaleTintAlpha)];
}

- (CGFloat)saturationDeltaFactor {
    return [self getFloatSettingsSelector:@selector(saturationDeltaFactor)];
}

- (void)setSaturationDeltaFactor:(CGFloat)saturationDeltaFactor {
    [self setSettingsValue:@(saturationDeltaFactor) forSelector:@selector(saturationDeltaFactor)];
}

// 避免审核风险
- (void)setSettingsValue:(id)value forSelector:(SEL)selector {
    [self.effectSettings setValue:value forKey:NSStringFromSelector(selector)];
}

- (CGFloat)getFloatSettingsSelector:(SEL)selector {
    return [[self.effectSettings valueForKey:NSStringFromSelector(selector)] floatValue];
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
