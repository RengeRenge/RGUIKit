//
//  UIScrollView+RGScroll.h
//  RGUIKit
//
//  Created by renge on 2019/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView(RGInset)

- (void)rg_setAdditionalContentInset:(UIEdgeInsets)inset safeArea:(UIEdgeInsets)safeArea;

- (CGFloat)rg_topOffsetY;
- (CGFloat)rg_bottomOffsetY;

- (BOOL)rg_isTop;
- (BOOL)rg_isBottom;

- (void)rg_scrollViewToTop:(BOOL)animated;
- (void)rg_scrollViewToBottom:(BOOL)animated;

@end

@interface UIViewController(RGInset)

- (void)rg_setFullFrameScrollView:(__kindof UIScrollView *)scrollView wtihAdditionalContentInset:(UIEdgeInsets)inset;

@end

NS_ASSUME_NONNULL_END
