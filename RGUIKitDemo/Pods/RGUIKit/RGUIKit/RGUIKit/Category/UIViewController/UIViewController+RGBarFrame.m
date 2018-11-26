//
//  UINavigationController+BarFrame.m
//  JusTalk
//
//  Created by juphoon on 2017/11/2.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIViewController+RGBarFrame.h"
#import "UIViewController+RGPresent.h"

static BOOL rg_isFringeScreen = NO;
static BOOL rg_isFringeScreenConfirm = NO;

#define BarFrame_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

@implementation UIViewController (RGBarFrame)

- (UINavigationBar *)_rg_navigationBar {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self navigationBar];
    }
    return self.navigationController.navigationBar;
}

- (BOOL)rg_displayedNavigationBar {
    return (self._rg_navigationBar && !self._rg_navigationBar.isHidden);
}

- (CGFloat)rg_layoutOriginY {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets.top;
    } else {
        return [self rg_barBottomY];
    }
}

- (CGFloat)rg_barBottomY {
    if (self.rg_displayedNavigationBar) {
        if (self._rg_navigationBar.translucent) {
            return CGRectGetMaxY([self._rg_navigationBar convertRect:self._rg_navigationBar.bounds toView:self.view]);
        } else {
            return 0.f;
        }
    } else {
        if (@available(iOS 11.0, *)) {
            return self.view.safeAreaInsets.top;
        } else {
            return self.rg_statusBarHeightIfNeed;
        }
    }
}

- (CGFloat)rg_barHeight {
    
    CGFloat searchBarHeight = 0.f;
    
    if (@available(iOS 11.0, *)) {
        if (self.navigationItem.searchController) {
            UISearchBar *searchBar = self.navigationItem.searchController.searchBar;
            if (searchBar) {
                searchBarHeight = searchBar.isHidden ? 0.f : CGRectGetHeight(searchBar.frame);
            }
        }
    }
    return self._rg_navigationBar.frame.size.height + self.rg_statusBarHeightIfNeed + searchBarHeight;
}

- (CGSize)rg_barSize {
    return CGSizeMake(self.navigationController.navigationBar.frame.size.width, self.rg_barHeight);
}

- (CGFloat)rg_statusBarHeightIfNeed {
    if (self.rg_needAddStatusBarHeight) {
        return self.rg_statusBarHeight;
    }
    return 0.f;
}

- (BOOL)rg_needAddStatusBarHeight {
    UIModalPresentationStyle style = self.navigationController ? self.navigationController.modalPresentationStyle : self.modalPresentationStyle;
    switch (style) {
        case UIModalPresentationPageSheet:
        case UIModalPresentationFormSheet:
        case UIModalPresentationPopover: {
            return NO;
        }
        default: {
            return YES;
        }
    }
}

- (CGFloat)rg_statusBarHeight {
    if (self.prefersStatusBarHidden) {
        return 0.f;
    }
    /*
     iPad 和 刘海屏幕 StatusBar 的高度是固定的
     iPhone 通话时，statusBar 高度增加，但是 view 的布局是从 statusBar 下面那条开始布局，所以取固定值 20
     */
    CGFloat statusBarHeight = (BarFrame_IS_PAD || UIViewController.rg_isFringeScreen) ? [UIApplication sharedApplication].statusBarFrame.size.height : 20;
    return statusBarHeight;
}

+ (BOOL)rg_isFringeScreen {
    
    if (rg_isFringeScreenConfirm) {
        return rg_isFringeScreen;
    }
    
    if (@available(iOS 11.0, *)) {
        
        if (rg_isFringeScreen) {
            return YES;
        }
        
        /* 使用这个方法判断刘海屏幕 只在 statusBar 不隐藏并且竖屏幕的时候有效 */
        if ([UIApplication sharedApplication].statusBarFrame.size.height > 40) {
            rg_isFringeScreen = YES;
        } else {
            UIEdgeInsets inset = [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
            if (inset.left || inset.right || inset.bottom) {
                rg_isFringeScreen = YES;
                rg_isFringeScreenConfirm = YES;
                return YES;
            }
            
            UIViewController *top = [UIViewController rg_topViewController];
            
            /* 认为非刘海屏幕左右没有安全区域 */
            inset = top.view.safeAreaInsets;
            if (inset.left || inset.right) {
                rg_isFringeScreen = YES;
                rg_isFringeScreenConfirm = YES;
            } else {
                UITabBar *tabBar = top.tabBarController.tabBar;
                if (tabBar) {
                    if (tabBar.isHidden) {
                        rg_isFringeScreen = top.view.safeAreaInsets.bottom > 0.f;
                    } else {
                        /* 认为刘海屏幕的 tabBar 必定有bottom */
                        rg_isFringeScreen = tabBar.safeAreaInsets.bottom > 0.f;
                        rg_isFringeScreenConfirm = YES;
                    }
                } else {
                    rg_isFringeScreen = top.view.safeAreaInsets.bottom > 0.f;
                    rg_isFringeScreenConfirm = YES;
                }
            }
        }
        return rg_isFringeScreen;
    } else {
        return NO;
    }
}

@end
