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
+ (UIImage *)rg_templateImageWithSize:(CGSize)imageSize;
+ (UIImage *)rg_templateImageNamed:(NSString *)name;
+ (UIImage *)rg_templateCircleImageWithSize:(CGSize)imageSize radius:(CGFloat)radius;
- (UIImage *)rg_imageWithColor:(UIColor *)color;
- (UIImage *)rg_applyingAlpha:(CGFloat)alpha;

- (UIColor *)rg_mainColor;
- (BOOL)rg_hasAlpha;


/**
 image size aspect fit size

 @param logicSize iOS view's size (ignore UIScreen.scale)
 @param stretch scale will not > 1 if NO
 */
- (CGSize)rg_sizeThatFits:(CGSize)logicSize stretch:(BOOL)stretch;


/**
 image size aspect fill size

 @param logicSize iOS view's size (ignore UIScreen.scale)
 */
- (CGSize)rg_sizeThatFill:(CGSize)logicSize;


/**
 iOS view's size (follow UIScreen.scale)
 
 @note if UIScreen.scale == self.scale, return self.size;
 */
- (CGSize)rg_logicSize;


/**
 true size
 */
- (CGSize)rg_pixSize;

/**
 relative size
 */
- (CGSize)rg_sizeWithScale:(CGFloat)scale;

@end
