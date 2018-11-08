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

@end

@interface UIImage (RGLayoutHelp)

/**
 水平翻转图片
 */
- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection;

@end
