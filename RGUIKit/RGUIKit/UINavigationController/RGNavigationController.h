//
//  RGNavigationController.h
//  CampTalk
//
//  Created by kikilee on 2018/4/20.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RGNavigationBackgroundStyleNone,
    RGNavigationBackgroundStyleNormal,
    RGNavigationBackgroundStyleShadow,
    RGNavigationBackgroundStyleAllTranslucent,
} RGNavigationBackgroundStyle;

@interface RGNavigationController : UINavigationController

@property (nonatomic, assign) RGNavigationBackgroundStyle barBackgroundStyle;
//@property (nonatomic, assign) UIStatusBarStyle barStyle; // UIStatusBarStyleLightContent

@property (nonatomic, strong) UIColor *tintColor;

+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root;
+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style;

@end

@interface UIViewController (RGNavigationController)

- (__kindof RGNavigationController *)rg_navigationController;

@end
