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
@property (nonatomic, assign) CGFloat barBackgroundAlpha;
@property (nonatomic, assign) BOOL hideSeparator;

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *titleColor;

+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root;
+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style;

@end

@interface UIViewController (RGNavigationController)

@property (nonatomic, copy, readonly) __kindof UIViewController *(^rg_pushedBy)(UIViewController *nvg);
@property (nonatomic, copy, readonly) __kindof UIViewController *(^rg_hidesBottomBarWhenPushed)(void);

- (__kindof RGNavigationController *)rg_navigationController;

@end
