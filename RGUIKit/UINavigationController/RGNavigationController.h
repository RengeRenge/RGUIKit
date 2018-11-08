//
//  RGNavigationController.h
//  CampTalk
//
//  Created by kikilee on 2018/4/20.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RGNavigationBackgroundStyleShadow,
    RGNavigationBackgroundStyleNormal,
    RGNavigationBackgroundStyleAllTranslucent,
} RGNavigationBackgroundStyle;

@interface RGNavigationController : UINavigationController

@property (nonatomic, assign) RGNavigationBackgroundStyle barBackgroundStyle;
//@property (nonatomic, assign) UIStatusBarStyle barStyle; // UIStatusBarStyleLightContent

@property (nonatomic, strong) UIColor *tintColor;

+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root;
+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style;

@end

@interface UIViewController (RGNavigationController)

- (RGNavigationController *)rg_navigationController;

@end
