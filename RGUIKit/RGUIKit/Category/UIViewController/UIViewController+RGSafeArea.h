//
//  UIViewController+SafeArea.h
//  JusTalk
//
//  Created by juphoon on 2017/11/7.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RGSafeArea)

- (UIEdgeInsets)rg_layoutSafeAreaInsets; // iOS 11 以下 top 为导航栏, bottom 为 tabBar

- (CGFloat)rg_layoutSafeAreaInsetsBottom;

- (CGFloat)rg_layoutBottomY;
- (CGFloat)rg_layoutTopY;

/// self.view.safeAreaInsets if available iOS 11 else UIEdgeInsetsZero
- (UIEdgeInsets)rg_viewSafeAreaInsets;

- (CGRect)rg_safeAreaBounds;
- (CGRect)rg_safeAreaTopBounds;
- (CGRect)rg_safeAreaBottomBounds;

- (CGRect)rg_safeAreaFix:(CGRect)rect;
- (CGRect)rg_safeAreaFixVertical:(CGRect)rect; // 在 (0, 0) 开始布局，之后使用此方法
- (CGRect)rg_safeAreaFixHorizontal:(CGRect)rect;

- (CGRect)rg_safeAreaFixTop:(CGRect)rect; // 默认 stretch:NO; 移动位置 不拉伸
- (CGRect)rg_safeAreaFixTop:(CGRect)rect stretch:(BOOL)stretch;

- (CGRect)rg_safeAreaFixBottom:(CGRect)rect;
- (CGRect)rg_safeAreaFixBottom:(CGRect)rect stretch:(BOOL)stretch;

- (CGRect)rg_safeAreaFixLeft:(CGRect)rect;
- (CGRect)rg_safeAreaFixLeft:(CGRect)rect stretch:(BOOL)stretch;

- (CGRect)rg_safeAreaFixRight:(CGRect)rect;
- (CGRect)rg_safeAreaFixRight:(CGRect)rect stretch:(BOOL)stretch;

- (CGRect)rg_safeAreaFixWidth:(CGRect)rect;
- (CGRect)rg_safeAreaFixHeight:(CGRect)rect;

- (CGRect)rg_safeAreaFixTop:(CGRect)rect originalTop:(CGFloat)top stretch:(BOOL)stretch;
- (CGRect)rg_safeAreaFixLeft:(CGRect)rect originalLeft:(CGFloat)left stretch:(BOOL)stretch;
- (CGRect)rg_safeAreaFixBottom:(CGRect)rect originalBottom:(CGFloat)bottom superViewHeight:(CGFloat)superHeight stretch:(BOOL)stretch;
- (CGRect)rg_safeAreaFixRight:(CGRect)rect originalRight:(CGFloat)right superViewWidth:(CGFloat)superWidth stretch:(BOOL)stretch;

//- (CGFloat)safeAreaTopY:(CGFloat)topY;
//- (CGFloat)safeAreaBottomY:(CGFloat)bottomY;
//- (CGFloat)safeAreaHeight:(CGFloat)height;
//
//- (CGFloat)safeAreaLeftX:(CGFloat)leftX;
//- (CGFloat)safeAreaRightX:(CGFloat)rightX;
//- (CGFloat)safeAreaWidth:(CGFloat)width;

@end
