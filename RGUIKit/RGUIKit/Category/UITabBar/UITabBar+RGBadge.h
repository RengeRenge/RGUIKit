//
//  UITabBar+Badge.h
//  JusTalk
//
//  Created by jiang  hao on 2017/7/6.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RGUITabbarBadgeType) {
    RGUITabbarBadgeTypeNone,
    RGUITabbarBadgeTypeNormal,
};

@interface UITabBar (RGBadge)

- (void)rg_showTabBarBadgeWithType:(RGUITabbarBadgeType)type atIndex:(NSInteger)index;
- (void)rg_showTabBarBadgeWithValue:(NSString *)value atIndex:(NSInteger)index;
- (void)rg_hideTabBarBadgeAtIndex:(NSInteger)index;

@end

@interface UIViewController (RGBadge)

- (void)rg_showTabBarBadgeWithType:(RGUITabbarBadgeType)type;
- (void)rg_showTabBarBadgeWithValue:(NSString *)value;
- (void)rg_hideTabBarBadge;

@end


