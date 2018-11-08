//
//  UITabBar+Badge.h
//  JusTalk
//
//  Created by jiang  hao on 2017/7/6.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RGUITabbarBadgeType) {
    RGUITabbarBadgeTypeNormal,
    RGUITabbarBadgeTypeWarning
};

@interface UITabBar (RGBadge)

- (void)rg_showBadgeWithType:(RGUITabbarBadgeType)type atIndex:(NSInteger)index;
- (void)rg_showBadgeWithValue:(NSString *)value atIndex:(NSInteger)index;
- (void)rg_hideBadgeAtIndex:(NSInteger)index;

@end

@interface UIViewController (RGBadge)

- (void)rg_showBadgeWithType:(RGUITabbarBadgeType)type;
- (void)rg_showBadgeWithValue:(NSString *)value;
- (void)rg_hideBadge;

@end


