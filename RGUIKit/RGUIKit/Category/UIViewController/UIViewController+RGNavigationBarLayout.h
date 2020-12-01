//
//  UIViewController+RGBarFrame.h
//  JusTalk
//
//  Created by juphoon on 2017/11/2.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RGNavigationBarLayout)

/**
 导航栏底部对于 view 的 y轴坐标
 */
- (CGFloat)rg_barBottomY;

/**
 viewSafeArea.top,
 在 iOS 11 以下的系统则为 rg_barBottomY,
 可以依据此数值在竖直方向开始局部
 */
- (CGFloat)rg_layoutOriginY;

- (CGFloat)rg_barHeight;

- (CGFloat)rg_statusBarHeight;

- (CGSize)rg_barSize;

- (BOOL)rg_displayedNavigationBar;

/**
 是刘海屏幕
 */
+ (BOOL)rg_isFringeScreen;

@end
