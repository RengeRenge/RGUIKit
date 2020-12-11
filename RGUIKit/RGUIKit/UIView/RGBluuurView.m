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

//@property (strong, nonatomic) UIViewPropertyAnimator *ani;

@end

@implementation RGBluuurView

+ (instancetype)new {
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    if (self = [super initWithEffect:effect]) {
        [self setup];
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
    self.effect = nil;
    self.effect = self.blurEffect;
}

- (RGBlurEffect *)blurEffect {
    if (_blurEffect == nil) {
        _blurEffect = [RGBlurEffect effectWithBlurRadius:0];
    }
    return _blurEffect;
}

#pragma mark - Properties

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

- (void)beginChange {
    self.changing = YES;
    
    RGBlurEffect *blurEffect = [RGBlurEffect effectWithStyle: self.blurEffect.style == UIBlurEffectStyleDark ? UIBlurEffectStyleLight : UIBlurEffectStyleDark];
    
    blurEffect.blurRadius = self.blurRadius;
    blurEffect.saturationDeltaFactor = self.saturationDeltaFactor;
    blurEffect.grayscaleTintAlpha = self.grayscaleTintAlpha;
    blurEffect.grayscaleTintLevel = self.grayscaleTintLevel;
    
    self.effect = nil;
    self.effect = blurEffect;
}

- (void)commitChange {
    self.changing = NO;
    [self _config];
}

#pragma mark - Private

- (void)_config {
    if (self.changing) {
        return;
    }
    self.effect = nil;
    if (self.blurEffect.blurRadius != 0) {
        self.effect = self.blurEffect;
    }
}

@end
