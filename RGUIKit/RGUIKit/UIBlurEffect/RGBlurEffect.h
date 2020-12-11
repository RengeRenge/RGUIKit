//
//  RGBlurEffect.h
//  RGUIKit
//
//  Created by renge on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGBlurEffect : UIBlurEffect

@property (nonatomic) CGFloat grayscaleTintLevel;
@property (nonatomic) CGFloat grayscaleTintAlpha;

@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) CGFloat saturationDeltaFactor;

@property (nonatomic, assign) UIBlurEffectStyle style;

+ (RGBlurEffect *)effectWithStyle:(UIBlurEffectStyle)style;
+ (RGBlurEffect *)effectWithBlurRadius:(CGFloat)blurRadius;

@end

NS_ASSUME_NONNULL_END

/*
 
 UIBlurEffectStyleLight
 
 graphicsQuality:        100
 backdrop visible:       YES
 grayscaleTintLevel:     1.00
 grayscaleTintAlpha:     0.30
 grayscaleTintMaskImage: (null)
 grayscaleTintMaskAlpha: 1.00
 colorTint:              (null)
 colorTintAlpha:         1.00
 colorTintMaskImage:     (null)
 colorTintMaskAlpha:     1.00
 blurRadius:             30.00  // 默认半径 30
 saturationDeltaFactor:  1.80
 filterMaskImage:        (null)
 filterMaskAlpha:        1.00
 combinedTintColor:      UIExtendedSRGBColorSpace 1 1 1 0.3
 */

/*
 UIBlurEffectStyleDark
 
 graphicsQuality:        100
 backdrop visible:       YES
 grayscaleTintLevel:     0.11
 grayscaleTintAlpha:     0.73
 grayscaleTintMaskImage: (null)
 grayscaleTintMaskAlpha: 1.00
 colorTint:              (null)
 colorTintAlpha:         1.00
 colorTintMaskImage:     (null)
 colorTintMaskAlpha:     1.00
 blurRadius:             20.00
 saturationDeltaFactor:  1.80
 filterMaskImage:        (null)
 filterMaskAlpha:        1.00
 combinedTintColor:      UIExtendedSRGBColorSpace 0.11 0.11 0.11 0.73
 */
