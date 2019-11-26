//
//  UIImage+JCPictureEdit.h
//  PictureEditor
//
//  Created by young on 2018/2/23.
//  Copyright © 2018年 young. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RGImageEdit)

/**
 对 view 进行截图
 */
- (UIImage *)rg_convertToImage;

/**
 对 view 的指定区域 进行截图
 
 @param rect 截图区域, CGRectZero 为全部截图
 */
- (UIImage *)rg_convertToImageInRect:(CGRect)rect;

/**
 对 view 进行截图
 
 @param size 目标图片大小 (会形变)
 */
- (UIImage *)rg_convertToImageWithSize:(CGSize)size;

@end

@interface UIScrollView (RGImageEdit)

/**
 对 scrollView 进行截图
 
 @param rect 截图区域, CGRectZero 为全部截图
 */
- (UIImage *)rg_captureInRect:(CGRect)rect;

@end

@interface UIImage (RGImageEdit)

/**
 在图片中截取某一区域
 
 @param rect 图片对应的倍数的区域
 @return 一倍图
 */
- (UIImage *)rg_cropInRect:(CGRect)rect;

/**
 在图片中截取某一区域

 @param pixRect 实际大小像素的区域
 @return 一倍图
 */
- (UIImage *)rg_cropInPixRect:(CGRect)pixRect;

/**
 获取指定倍数的图片
 */
- (UIImage *)rg_imageWithScale:(CGFloat)scale;

/**
 获取当前屏幕倍数的图片
 */
- (UIImage *)rg_imageWithScreenScale;

/**
 在图片上覆盖图片
 */
- (UIImage *)rg_coveredWithImage:(UIImage *)image pixRect:(CGRect)pixRect;

/**
 在图片上覆盖图片
 */
- (UIImage *)rg_coveredWithImage:(UIImage *)image rect:(CGRect)rect;


/// 在图片上覆盖文字
/// @param text 文字
/// @param attributes 文字属性
/// @param boundingSize 文字约束的大小
/// @param rect 自定义文字的 frame
- (UIImage *)rg_coveredWithText:(NSString *)text
                     attributes:(NSDictionary *)attributes
                   boundingSize:(CGSize)boundingSize
                           rect:(CGRect(NS_NOESCAPE^)(CGSize textSize, CGSize imageSize))rect;

/**
 把图片的方向调正
 */
- (UIImage *)rg_fixOrientation;


/**
 竖直方向拼接图片, 生成的图片的宽度为自己的宽度

 @param appendImage 在下面的图片
 @return 新生成的图片
 */
- (UIImage *)rg_appendImage:(UIImage *)appendImage;

/**
 竖直方向拼接图片 从图片拼接在主图片的下面

 @param appendImage 主图片，生成的图片的宽度为masterImage的宽度
 @param masterImage 从图片，拼接在masterImage的下面
 */
+ (UIImage *)rg_masterImage:(UIImage *)masterImage appendImage:(UIImage *)appendImage;

@end
