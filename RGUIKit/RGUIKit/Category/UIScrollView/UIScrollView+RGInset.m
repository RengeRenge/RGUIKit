//
//  UIScrollView+RGScroll.m
//  RGUIKit
//
//  Created by renge on 2019/8/24.
//

#import "UIScrollView+RGInset.h"
#import <RGUIKit/RGUIKit.h>

@implementation UIViewController(RGInset)

- (void)rg_setFullFrameScrollView:(__kindof UIScrollView *)scrollView wtihAdditionalContentInset:(UIEdgeInsets)inset {
    [scrollView rg_setAdditionalContentInset:inset safeArea:self.rg_layoutSafeAreaInsets];
}

@end

@implementation UIScrollView(RGInset)

- (void)rg_setAdditionalContentInset:(UIEdgeInsets)inset safeArea:(UIEdgeInsets)safeArea {
    if (@available(iOS 11.0, *)) {
        self.contentInset = inset;
    } else {
        self.contentInset = UIEdgeInsetsMake(safeArea.top+inset.top, safeArea.left+inset.left, safeArea.bottom+inset.bottom, safeArea.right+inset.right);
    }
}

- (CGFloat)rg_topOffsetY {
    CGFloat offsetY = 0;
    if (@available(iOS 11.0, *)) {
        offsetY = -self.adjustedContentInset.top;
    } else {
        offsetY = -self.contentInset.top;
    }
    return offsetY;
}

- (CGFloat)rg_bottomOffsetY {
    CGFloat offsetY = self.contentSize.height - self.frame.size.height;
    if (@available(iOS 11.0, *)) {
        offsetY += self.adjustedContentInset.bottom;
    } else {
        offsetY += self.contentInset.bottom;
    }
    return MAX(offsetY, self.rg_topOffsetY);
}

- (BOOL)rg_isTop {
    return fabs(self.rg_topOffsetY - self.contentOffset.y) < 0.5;
}

- (BOOL)rg_isBottom {
    return fabs(self.rg_bottomOffsetY - self.contentOffset.y) < 0.5;
}

- (void)rg_scrollViewToTop:(BOOL)animated {
    CGPoint offset = CGPointMake(self.contentOffset.x, self.rg_topOffsetY);
    [self setContentOffset:offset animated:animated];
}

- (void)rg_scrollViewToBottom:(BOOL)animated {
    CGPoint offset = CGPointMake(self.contentOffset.x, self.rg_bottomOffsetY);
    [self setContentOffset:offset animated:animated];
}

@end
