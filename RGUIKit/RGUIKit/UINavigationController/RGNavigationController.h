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

@class RGNavigationController;

@interface RGNavigationBarAppearance : NSObject

@property (nonatomic, assign) RGNavigationBackgroundStyle barBackgroundStyle;
@property (nonatomic, assign) BOOL hideSeparator;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@end

@interface RGNavigationController : UINavigationController

#pragma mark - Appearance Setting

/// default set value for standardAppearance
@property (nonatomic, assign) RGNavigationBackgroundStyle barBackgroundStyle;
/// default set value for standardAppearance
@property (nonatomic, assign) BOOL hideSeparator;
/// default set value for standardAppearance
@property (nonatomic, strong) UIColor *titleColor;
/// default set value for standardAppearance
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) RGNavigationBarAppearance *standardAppearance;


/// available  iOS 13
@property (nonatomic, strong) RGNavigationBarAppearance *scrollEdgeAppearance;
@property (nonatomic, assign) BOOL scrollEdgeKeepPaceWithStandard;

#pragma mark - Universal Setting

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) CGFloat barBackgroundAlpha;

+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root;
+ (__kindof RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style;

@end

@interface UIViewController (RGNavigationController)

@property (nonatomic, copy, readonly) __kindof UIViewController *(^rg_pushedBy)(UIViewController *nvg);
@property (nonatomic, copy, readonly) __kindof UIViewController *(^rg_hidesBottomBarWhenPushed)(void);

- (__kindof RGNavigationController *)rg_navigationController;

@end
