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

 @param R must pass float type
 @return color
 */
+ (UIColor *)rg_colorWithRGBA:(CGFloat)R, ...;


/**
 get a color with r g b a, like 100, 150, 200
 */
+ (UIColor *)rg_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)rg_colorWithRGBHex:(UInt32)hex;

@end

NS_ASSUME_NONNULL_END
