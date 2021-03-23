//
//  UIView+Layout.h
//  JusTalk
//
//  Created by juphoon on 2017/12/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UIView (RGLayoutHelp)

/**
 布局的方向
 */
- (BOOL)rg_layoutLeftToRight;

/**
 从左到右的局转化从右到左(RTL)的布局

 @param frame 从左到右的布局
 @param width 父视图的宽度
 */
- (void)rg_setRTLFrame:(CGRect)frame width:(CGFloat)width;

/**
 从左到右的局转化从右到左(RTL)的布局

 @param frame 从左到右的布局
 @note 必须已经加到父视图上
 */
- (void)rg_setRTLFrame:(CGRect)frame;

/**
 将这个 view 从左到右的局转化从右到左(RTL)的布局
 @note 必须已经加到父视图上
 */
- (void)rg_setFrameToFitRTL;


/**
 获取 RTL Frame
 */
+ (CGRect)rg_RTLFrameWithLTRFrame:(CGRect)frame superWidth:(CGFloat)width;


+ (void)rg_setSemanticContentAttribute:(UISemanticContentAttribute)UISemanticContentAttribute API_AVAILABLE(ios(9.0));

- (CGPoint)rg_selfCenter;
- (CGPoint)rg_centerInSuperView;
- (CGPoint)rg_centerInSuperViewOriginZero;

- (CGFloat)rg_bottom;
- (CGFloat)rg_top;
- (CGFloat)rg_leading;
- (CGFloat)rg_trailing;

- (CGFloat)rg_leadingForBounds;
- (CGFloat)rg_trailingForBounds;

- (CGSize)rg_size;
- (CGFloat)rg_width;
- (CGFloat)rg_height;

@end

@interface UIImage (RGLayoutHelp)

/**
 水平翻转图片
 */
- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection;

@end

CGPoint RG_CGSelfCenter(CGRect frame);
CGRect RG_CGRectMake(CGPoint center, CGSize size);

/// 基于屏幕倍数，进行像素取整
CGFloat RG_Flat(CGFloat value);
/// 返回像素对齐的 Rect
CGRect RG_CGRectMakeFlat(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
/// 返回像素对齐的 Rect
CGRect RG_CGRectFlat(CGRect frame);
