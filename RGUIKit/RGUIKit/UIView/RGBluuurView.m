//
//  MLWBluuurView.m
//  Bluuur
//
//  Copyright (c) 2016 Machine Learning Works
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RGBluuurView.h"
#import "RGBlurEffect.h"

#define RGBluuurViewMaxBlurRadius 30

// grayscaleTintLevel
// grayscaleTintAlpha
// lightenGrayscaleWithSourceOver
// colorTint
// colorTintAlpha
// colorBurnTintLevel
// colorBurnTintAlpha
// darkeningTintAlpha
// darkeningTintHue
// darkeningTintSaturation
// darkenWithSourceOver
// blurRadius
// saturationDeltaFactor
// scale
// zoom

@interface RGBluuurView ()

@property (strong, nonatomic) RGBlurEffect *blurEffect;

@property (assign, nonatomic) BOOL changing;

@property (assign, nonatomic) UIBlurEffectStyle changingStyle;

@property (strong, nonatomic) UIVisualEffectView *subEffectView;

//@property (strong, nonatomic) UIViewPropertyAnimator *ani;

@end

@implementation RGBluuurView

+ (instancetype)new {
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithEffect:(RGBlurEffect *)effect {
    if (self = [super initWithEffect:effect]) {
        self.blurEffect = effect;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [super setEffect:nil];
    self.effect = self.blurEffect;
}

- (RGBlurEffect *)blurEffect {
    if (_blurEffect == nil) {
        _blurEffect = [RGBlurEffect effectWithBlurRadius:0];
    }
    return _blurEffect;
}

- (void)setEffect:(RGBlurEffect *)effect {
    if (_blurEffect != effect) {
        _blurEffect = effect;
        [self _config];
    }
}

- (RGBlurEffect *)effect {
    return _blurEffect;
}

- (UIVisualEffectView *)vibrancyEffectView {
    if (!_subEffectView) {
        UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:self.effect]];
        _subEffectView = subEffectView;
        
        subEffectView.frame = self.bounds;
        subEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView insertSubview:subEffectView atIndex:0];
    }
    return _subEffectView;
}

#pragma mark - Properties

- (UIBlurEffectStyle)style {
    return self.blurEffect.style;
}

- (void)setStyle:(UIBlurEffectStyle)style {
    if (self.changing) {
        return;
    }
    self.changingStyle = -1;
    if (style != self.blurEffect.style) {
        _blurEffect = [RGBlurEffect effectWithStyle:style blurRadius:self.blurRadius];
        [self _config];
    }
}

- (CGFloat)grayscaleTintLevel {
    return self.blurEffect.grayscaleTintLevel;
}

- (void)setGrayscaleTintLevel:(CGFloat)grayscaleTintLevel {
    self.blurEffect.grayscaleTintLevel = grayscaleTintLevel;
    [self _config];
}

- (CGFloat)grayscaleTintAlpha {
    return self.blurEffect.grayscaleTintAlpha;
}

- (void)setGrayscaleTintAlpha:(CGFloat)grayscaleTintAlpha {
    self.blurEffect.grayscaleTintAlpha = grayscaleTintAlpha;
    [self _config];
}

- (CGFloat)blurRadius {
    return self.blurEffect.blurRadius;
}

- (void)setBlurRadius:(CGFloat)blurRadius {
    self.blurEffect.blurRadius = blurRadius;
    [self _config];
}

- (CGFloat)saturationDeltaFactor {
    return self.blurEffect.saturationDeltaFactor;
}

- (void)setSaturationDeltaFactor:(CGFloat)saturationDeltaFactor {
    self.blurEffect.saturationDeltaFactor = saturationDeltaFactor;
    [self _config];
}

- (void)beginChangeToStyle:(UIBlurEffectStyle)style {
    self.changing = YES;
    self.changingStyle = style;
    
    RGBlurEffect *blurEffect = [RGBlurEffect effectWithStyle:[self _otherStyleWithStyle:style] effect:self.blurEffect];
    super.effect = blurEffect;
    
    _subEffectView.effect = [UIVibrancyEffect effectForBlurEffect:self.effect];
}

- (void)commitChange {
    self.changing = NO;
    if (self.changingStyle != -1) {
        self.style = self.changingStyle;
    }
    [self _config];
}

#pragma mark - Private

- (void)_config {
    if (self.changing) {
        return;
    }
    
    if (_blurEffect.blurRadius == 0) {
        super.effect = nil;
    } else {
        super.effect = nil;
        super.effect = _blurEffect;
        _subEffectView.effect = [UIVibrancyEffect effectForBlurEffect:self.effect];
    }
}

- (UIBlurEffectStyle)_otherStyleWithStyle:(UIBlurEffectStyle)style {
    return style == UIBlurEffectStyleDark ? UIBlurEffectStyleLight : UIBlurEffectStyleDark;
}

@end
