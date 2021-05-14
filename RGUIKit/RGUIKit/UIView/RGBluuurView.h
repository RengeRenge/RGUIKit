//
//  MLWBluuurView.h
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

#import <UIKit/UIKit.h>
#import <RGUIKit/RGBlurEffect.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGBluuurView : UIVisualEffectView

@property (nonatomic, copy, nullable) RGBlurEffect *effect;

@property (nonatomic, assign) UIBlurEffectStyle style;

@property (nonatomic) CGFloat grayscaleTintLevel;
@property (nonatomic) CGFloat grayscaleTintAlpha;
@property (nonatomic) CGFloat saturationDeltaFactor;
@property (nonatomic) CGFloat blurRadius;

+ (instancetype)new;
- (instancetype)initWithEffect:(RGBlurEffect *__nullable)effect;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)setEffect:(RGBlurEffect *__nullable)effect;

/*
 Animate Sample.
 
 [self.blurView beginChangeToStyle:UIBlurEffectStyleLight];
 
 [UIView animateWithDuration:0.6 animations:^{
     self.blurView.blurRadius = 50;
     [self.blurView commitChange];
 }];
 
 */
- (void)beginChangeToStyle:(UIBlurEffectStyle)style;
- (void)commitChange;

- (UIVisualEffectView *)vibrancyEffectView;

@end

NS_ASSUME_NONNULL_END
