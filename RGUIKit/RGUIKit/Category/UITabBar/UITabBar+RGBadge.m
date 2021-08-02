//
//  UITabBar+Badge.m
//  JusTalk
//
//  Created by jiang  hao on 2017/7/6.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UITabBar+RGBadge.h"
#import "UIImage+RGTint.h"
#import "UIView+RGLayoutHelp.h"
#import <objc/runtime.h>
#import <RGObserver/RGObserver.h>

#define kUITabbarCustomBadgeTag 1000
#define kUITabbarCustomNormalBadgeWidth 10
#define kUITabbarCustomWarningBadgeWidth 18

static const void *kRGTabBarBadgeMap = "kRGTabBarBadgeMap";

@interface UITabBar ()

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, UIButton *> *rg_tabBarBadgeMap;

@end

@implementation UITabBar (RGBadge)

- (NSMutableDictionary <NSNumber *, UIButton *> *)rg_tabBarBadgeMap {
    return objc_getAssociatedObject(self, kRGTabBarBadgeMap);
}

- (void)setRg_tabBarBadgeMap:(NSMutableDictionary<NSNumber *,UIButton *> *)rg_tabBarBadgeMap {
    objc_setAssociatedObject(self, kRGTabBarBadgeMap, rg_tabBarBadgeMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)rg_showTabBarBadgeWithValue:(NSString *)value atIndex:(NSInteger)index {
    if (index < self.items.count) {
        [self rg_hideTabBarBadgeAtIndex:index];
        UITabBarItem *item = self.items[index];
        item.badgeValue = value;
    }
}

- (void)rg_showTabBarBadgeWithType:(RGUITabbarBadgeType)type atIndex:(NSInteger)index {
    if (!self.items.count) {
        return;
    }
    [self rg_removeBadgeOnItemIndex:index];
    UIButton *badgeView = [[UIButton alloc] init];
    badgeView.tag = kUITabbarCustomBadgeTag + index;
    badgeView.userInteractionEnabled = NO;
    CGFloat width = kUITabbarCustomNormalBadgeWidth;
    switch (type) {
        case RGUITabbarBadgeTypeNormal:
            break;
        default:
            [self rg_hideTabBarBadgeAtIndex:index];
            return;
    }
    badgeView.layer.cornerRadius = width / 2;
    badgeView.layer.masksToBounds = YES;
    badgeView.tintColor = [UIColor redColor];
    [badgeView setBackgroundImage:[UIImage rg_templateImageWithSize:CGSizeMake(width, width)] forState:UIControlStateNormal];
    badgeView.titleLabel.textAlignment = NSTextAlignmentCenter;
    badgeView.titleLabel.font = [UIFont systemFontOfSize:13];
    badgeView.adjustsImageWhenHighlighted = NO;
    badgeView.clipsToBounds = YES;
    badgeView.frame = CGRectMake(0, 0, width, width);
    
    if (!self.rg_tabBarBadgeMap) {
        self.rg_tabBarBadgeMap = [[NSMutableDictionary alloc] init];
        [self rg_addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [self rg_addObserver:self forKeyPath:@"semanticContentAttribute" options:NSKeyValueObservingOptionNew context:nil];
    }
    [self.rg_tabBarBadgeMap setObject:badgeView forKey:@(index)];
    [self __rg_addBadgeView:badgeView atIndex:index];
}

- (BOOL)__rg_addBadgeView:(UIButton *)badgeView atIndex:(NSInteger)index {
    
    BOOL didFind = NO;
    
    BOOL layoutLeftToRight = self.rg_layoutLeftToRight;
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            CGFloat tabWidth = subView.frame.size.width;
            NSInteger i = (subView.frame.origin.x + tabWidth / 2.0f) / tabWidth;
            if (!layoutLeftToRight) {
                i = self.items.count - 1 - i;
            }
            if (i == index) {
                
                __block UIView *tabBarButtonLabel = nil;
                
                [[subView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[UIImageView class]]) {
                        CGFloat x = 0;
                        CGFloat width = badgeView.frame.size.width;
                        
                        if (layoutLeftToRight) {
                            x = CGRectGetWidth(obj.frame) - width / 2;
                        } else {
                            x =  - width / 2;
                        }
                        badgeView.frame = CGRectIntegral(CGRectMake(x, 0, width, width));
                        badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                        [obj addSubview:badgeView];
                        *stop = YES;
                    }
                    
                    // 找到 tabBarButtonLabel
                    if ([obj respondsToSelector:@selector(text)]) {
                        tabBarButtonLabel = obj;
                    }
                }];
                
                // 如果没有添加到适合的控件上 可能是 tabBarItem 的图片没有设置 此时直接添加到 UITabBarButton 上
                if (!badgeView.superview) {
                    [subView addSubview:badgeView];
                    CGFloat width = badgeView.frame.size.width;
                    CGFloat height = badgeView.frame.size.height;
                    
                    if (tabBarButtonLabel) {
                        badgeView.center = CGPointMake(CGRectGetMaxX(tabBarButtonLabel.frame), height / 2.f);
                    } else {
                        badgeView.center = CGPointMake(subView.bounds.size.width - width / 2.f, height / 2.f);
                    }
                    if (!layoutLeftToRight) {
                        [badgeView rg_setFrameToFitRTL];
                    }
                    badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
                }
                didFind = YES;
                break;
            }
        }
    }
    return didFind;
}

- (void)rg_hideTabBarBadgeAtIndex:(NSInteger)index {
    if (index < self.items.count) {
        UITabBarItem *item = self.items[index];
        item.badgeValue = nil;
        [self rg_removeBadgeOnItemIndex:index];
    }
}

- (void)rg_removeBadgeOnItemIndex:(NSInteger)index {
    NSNumber *key = @(index);
    UIView *badgeView = [self.rg_tabBarBadgeMap objectForKey:key];
    [badgeView removeFromSuperview];
    [self.rg_tabBarBadgeMap removeObjectForKey:key];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self &&
        ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"semanticContentAttribute"])) {
        if (self.rg_tabBarBadgeMap.allKeys.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.rg_tabBarBadgeMap.allKeys.count > 0) {
                    [self.rg_tabBarBadgeMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIButton * _Nonnull badgeView, BOOL * _Nonnull stop) {
                        [badgeView removeFromSuperview];
                        [self __rg_addBadgeView:badgeView atIndex:key.integerValue];
                    }];
                }
            });
        }
    }
}

@end

@implementation UIViewController (RGBadge)

- (UITabBarItem *)rg_tabBarItem {
    if (self.navigationController) {
        return self.navigationController.tabBarItem;
    }
    return self.tabBarItem;
}

- (void)rg_showTabBarBadgeWithType:(RGUITabbarBadgeType)type {
    if (!self.tabBarController) {
        return;
    }
    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:self.rg_tabBarItem];
    [self.tabBarController.tabBar rg_showTabBarBadgeWithType:type atIndex:index];
}

- (void)rg_showTabBarBadgeWithValue:(NSString *)value {
    if (!self.tabBarController) {
        return;
    }
    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:self.rg_tabBarItem];
    [self.tabBarController.tabBar rg_showTabBarBadgeWithValue:value atIndex:index];
}

- (void)rg_hideTabBarBadge {
    if (!self.tabBarController) {
        return;
    }
    UITabBarItem *tabBarItem = self.rg_tabBarItem;
    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:tabBarItem];
    [self.tabBarController.tabBar rg_hideTabBarBadgeAtIndex:index];
}

@end
