//
//  UIViewController+SafeArea.m
//  JusTalk
//
//  Created by juphoon on 2017/11/7.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIViewController+RGSafeArea.h"
#import "UIViewController+RGNavigationBarLayout.h"

@implementation UIViewController (RGSafeArea)

- (UIEdgeInsets)rg_layoutSafeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(self.rg_layoutOriginY, 0, self.rg_layoutSafeAreaInsetsBottom, 0);
    }
}

- (CGFloat)rg_layoutSafeAreaInsetsBottom {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.bottom;
    } else {
        CGFloat bottom = 0.f;
        if (self.tabBarController && !self.tabBarController.tabBar.hidden) {
            bottom = self.tabBarController.tabBar.frame.size.height;
        }
        return bottom;
    }
}

- (CGFloat)rg_layoutBottomY {
    return self.view.bounds.size.height - self.rg_layoutSafeAreaInsetsBottom;
}

- (CGFloat)rg_layoutTopY {
    return self.rg_layoutOriginY;
}

- (UIEdgeInsets)rg_viewSafeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGRect)rg_safeAreaBounds {
    return [self rg_safeAreaFix:self.view.bounds];
}

- (CGRect)rg_safeAreaTopBounds {
    CGRect rect = self.view.bounds;
    rect.size.height = [self rg_safeAreaFixTop:rect stretch:NO].origin.y;
    return rect;
}

- (CGRect)rg_safeAreaBottomBounds {
    CGRect rect = self.view.bounds;
    CGFloat bottom = self.rg_viewSafeAreaInsets.bottom;
    rect.origin.y = rect.size.height - bottom;
    rect.size.height = bottom;
    return rect;
}

- (CGRect)rg_safeAreaFix:(CGRect)rect {
    
    rect = [self rg_safeAreaFixVertical:rect];
    rect = [self rg_safeAreaFixHorizontal:rect];
    return rect;
}

- (CGRect)rg_safeAreaFixVertical:(CGRect)rect {
    rect = [self rg_safeAreaFixTop:rect stretch:NO];
    rect = [self rg_safeAreaFixHeight:rect];
    return rect;
}

- (CGRect)rg_safeAreaFixHorizontal:(CGRect)rect {
    rect = [self rg_safeAreaFixLeft:rect stretch:NO];
    rect = [self rg_safeAreaFixWidth:rect];
    return rect;
}

- (CGRect)rg_safeAreaFixTop:(CGRect)rect {
    return [self rg_safeAreaFixTop:rect stretch:NO];
}

- (CGRect)rg_safeAreaFixTop:(CGRect)rect stretch:(BOOL)stretch {
    CGFloat top;
    if (!self.navigationController || self.navigationController.navigationBar.isHidden) {
        top = self.rg_viewSafeAreaInsets.top;
    } else {
        top = self.rg_layoutOriginY;
    }
    
    if (stretch) {
        rect.size.height += top;
    } else {
        rect.origin.y += top;
    }
    return rect;
}

- (CGRect)rg_safeAreaFixBottom:(CGRect)rect {
    return [self rg_safeAreaFixBottom:rect stretch:NO];
}

- (CGRect)rg_safeAreaFixBottom:(CGRect)rect stretch:(BOOL)stretch {
    CGFloat bottom = self.rg_viewSafeAreaInsets.bottom;
    rect.origin.y -= bottom;
    if (stretch) {
        rect.size.height += bottom;
    }
    return rect;
}

- (CGRect)rg_safeAreaFixLeft:(CGRect)rect {
    return [self rg_safeAreaFixLeft:rect stretch:NO];
}

- (CGRect)rg_safeAreaFixLeft:(CGRect)rect stretch:(BOOL)stretch {
    CGFloat left = self.rg_viewSafeAreaInsets.left;
    if (stretch) {
        rect.size.width += left;
    } else {
        rect.origin.x += self.rg_viewSafeAreaInsets.left;
    }
    return rect;
}

- (CGRect)rg_safeAreaFixRight:(CGRect)rect {
    return [self rg_safeAreaFixRight:rect stretch:NO];
}

- (CGRect)rg_safeAreaFixRight:(CGRect)rect stretch:(BOOL)stretch {
    CGFloat right = self.rg_viewSafeAreaInsets.right;
    rect.origin.x -= right;
    if (stretch) {
        rect.size.width += right;
    }
    return rect;
}

- (CGRect)rg_safeAreaFixWidth:(CGRect)rect {
    rect.size.width -= (self.rg_viewSafeAreaInsets.left + self.rg_viewSafeAreaInsets.right);
    return rect;
}

- (CGRect)rg_safeAreaFixHeight:(CGRect)rect {
    if (self.navigationController) {
        rect.size.height -= (self.rg_viewSafeAreaInsets.bottom + self.rg_layoutOriginY);
    } else {
        rect.size.height -= (self.rg_viewSafeAreaInsets.top + self.rg_viewSafeAreaInsets.bottom);
    }
    return rect;
}

- (CGRect)rg_safeAreaFixTop:(CGRect)rect originalTop:(CGFloat)top stretch:(BOOL)stretch {
    rect.origin.y = top;
    return [self rg_safeAreaFixTop:rect stretch:stretch];
}

- (CGRect)rg_safeAreaFixLeft:(CGRect)rect originalLeft:(CGFloat)left stretch:(BOOL)stretch {
    rect.origin.x = left;
    return [self rg_safeAreaFixLeft:rect stretch:stretch];
}

- (CGRect)rg_safeAreaFixBottom:(CGRect)rect originalBottom:(CGFloat)bottom superViewHeight:(CGFloat)superHeight stretch:(BOOL)stretch {
    rect.origin.y = superHeight - bottom;
    return [self rg_safeAreaFixBottom:rect stretch:stretch];
}

- (CGRect)rg_safeAreaFixRight:(CGRect)rect originalRight:(CGFloat)right superViewWidth:(CGFloat)superWidth stretch:(BOOL)stretch {
    rect.origin.x = superWidth - right;
    return [self rg_safeAreaFixRight:rect stretch:stretch];
}

//- (CGFloat)safeAreaTopY:(CGFloat)topY {
//    return self.rg_viewSafeAreaInsets.top + topY;
//}
//
//- (CGFloat)safeAreaBottomY:(CGFloat)bottomY {
//    return bottomY - self.rg_viewSafeAreaInsets.bottom;
//}
//
//- (CGFloat)safeAreaHeight:(CGFloat)height {
//    return height - self.rg_viewSafeAreaInsets.bottom - self.rg_viewSafeAreaInsets.top;
//}
//
//- (CGFloat)safeAreaLeftX:(CGFloat)leftX {
//    return self.rg_viewSafeAreaInsets.left + leftX;
//}
//
//- (CGFloat)safeAreaRightX:(CGFloat)rightX {
//    return rightX - self.rg_viewSafeAreaInsets.right;
//}
//
//- (CGFloat)safeAreaWidth:(CGFloat)width {
//    return width - self.rg_viewSafeAreaInsets.left - self.rg_viewSafeAreaInsets.right;
//}

@end
