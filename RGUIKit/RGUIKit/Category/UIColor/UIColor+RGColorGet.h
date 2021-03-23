//
//  UIColor+RGColorGet.h
//  Pods-RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(RGColorGet)

+ (UIColor *)rg_randomColor;


/**
 get a color with r g b a

 @param R must pass double type
 @return color
 */
+ (UIColor *)rg_colorWithRGBA:(double)R, ...;


/**
 get a color with r g b a, like 100, 150, 200
 */
+ (UIColor *)rg_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)rg_colorWithRGBHexString:(NSString *)hexString;
+ (UIColor *)rg_colorWithRGBHex:(UInt32)hex;

@end


@interface UIColor(RGDynamic)

+ (UIColor *)rg_colorWithDynamicProvider:(UIColor *(^)(BOOL dark))dynamicProvider;

/// white -> black
+ (UIColor *)rg_systemBackgroundColor;
+ (UIColor *)rg_secondarySystemBackgroundColor;

+ (UIColor *)rg_systemGroupedBackgroundColor;

+ (UIColor *)rg_separatorColor;

/// black -> white
+ (UIColor *)rg_labelColor;
+ (UIColor *)rg_secondaryLabelColor;
+ (UIColor *)rg_placeholderTextColor;

@end

NS_ASSUME_NONNULL_END
