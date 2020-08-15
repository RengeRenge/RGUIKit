//
//  UIImage+Tint.h
//  JusTel
//
//  Created by Cathy on 12-8-15.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RGTint)

+ (UIImage *)rg_coloredImage:(UIColor *)color size:(CGSize)imageSize;

+ (UIImage *)rg_circleImageWithColor:(UIColor *)color size:(CGSize)imageSize radius:(CGFloat)radius;
+ (UIImage *)rg_circleImageWithImageSize:(CGSize)imageSize
                              circleRect:(CGRect)circleRect
                                  radius:(CGFloat)radius
                               fillColor:(UIColor *)fillColor
                             borderColor:(UIColor *)borderColor
                             borderWidth:(CGFloat)borderWidth;

+ (UIImage *)rg_templateCircleImageWithSize:(CGSize)imageSize radius:(CGFloat)radius;
+ (UIImage *)rg_templateImageWithSize:(CGSize)imageSize;
+ (UIImage *)rg_templateImageNamed:(NSString *)name;
- (UIImage *)rg_imageWithColor:(UIColor *)color;
- (UIImage *)rg_applyingAlpha:(CGFloat)alpha;

- (UIColor *)rg_mainColorWithIgnoreColor:(UIColor *)ignoreColor;
- (UIColor *)rg_mainColor;

- (BOOL)rg_hasAlpha;
- (CGBitmapInfo)rg_bitmapInfo;

@end
