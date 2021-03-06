//
//  RGNavigationController.m
//  CampTalk
//
//  Created by kikilee on 2018/4/20.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import "RGNavigationController.h"
#import "UIBezierPath+RGDraw.h"
#import "UIViewController+RGNavigationBarLayout.h"
#import "UINavigationBar+RGAlpha.h"
#import <RGObserver/RGObserver.h>

void *RGNavigationControllerOBKey = "RGNavigationController";

@interface RGNavigationController ()

@property (nonatomic, strong) UIImage *cacheBg;
@property (nonatomic, strong) UIImage *cacheBgLandscape;

@end

@implementation RGNavigationController

+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root {
    return [self navigationWithRoot:root style:0];
}

+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style {
    RGNavigationController *ngv = [[self alloc] initWithRootViewController:root];
    ngv.barBackgroundStyle = style;
    return ngv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
    [self performSelector:@selector(configBar) withObject:nil afterDelay:0.f inModes:@[NSRunLoopCommonModes]];
    
    [self.navigationBar rg_addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:RGNavigationControllerOBKey];
    [self.navigationBar rg_addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:RGNavigationControllerOBKey];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.navigationBar.tintColor = tintColor;
    if (!_titleColor) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navigationBar.tintColor};
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (titleColor) {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};
    } else {
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navigationBar.tintColor};
    }
}

- (void)setBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    self.navigationBar.rg_backgroundAlpha = barBackgroundAlpha;
}

- (CGFloat)barBackgroundAlpha {
    return self.navigationBar.rg_backgroundAlpha;
}

- (void)setBarBackgroundStyle:(RGNavigationBackgroundStyle)barBackgroundStyle {
    _barBackgroundStyle = barBackgroundStyle;
    if (self.isViewLoaded) {
        [self configBar];
    } else {
        [self performConfigBar];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (RGNavigationControllerOBKey == context) {
        [self performConfigBar];
    }
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self performConfigBar];
}

- (void)performConfigBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
    [self performSelector:@selector(configBar) withObject:nil afterDelay:0.f inModes:@[NSRunLoopCommonModes]];
}

- (void)configBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
    switch (_barBackgroundStyle) {
        case RGNavigationBackgroundStyleNormal:
            [self.navigationBar setTranslucent:YES];
            [self.navigationBar setShadowImage:nil];
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
            [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompactPrompt];
            break;
        case RGNavigationBackgroundStyleAllTranslucent: {
            [self.navigationBar setTranslucent:YES];
            UIImage *barBg = [UIImage new];
            [self.navigationBar setShadowImage:barBg];
            [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsCompact];
            [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsCompactPrompt];
            break;
        }
        case RGNavigationBackgroundStyleShadow: {
            [self.navigationBar setTranslucent:YES];
            [self.navigationBar setShadowImage:[UIImage new]];
            [self.navigationBar setBackgroundImage:self.gradientBarBg forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setBackgroundImage:self.gradientBarBg_landscape forBarMetrics:UIBarMetricsCompact];
            [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompactPrompt];
            break;
        }
        default:
            break;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.__topViewController preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.__topViewController;
}

- (BOOL)prefersStatusBarHidden {
    return [self.__topViewController prefersStatusBarHidden];
}

- (UIViewController *)__topViewController {
    UIViewController *topViewController = self.topViewController;
    while (topViewController.presentedViewController) {
        UIViewController *next = topViewController.presentedViewController;
        if (next.isBeingDismissed || [next isKindOfClass:UIAlertController.class]) {
            break;
        }
        topViewController = topViewController.presentedViewController;
    }
    return topViewController;
}

#pragma mark - draw image

- (UIImage *)gradientBarBg {
    CGFloat top = 20;
    if (@available(iOS 11.0, *)) {
        top = self.view.safeAreaInsets.top;
    }
    CGSize size = CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height + top);
    if (self.cacheBg && CGSizeEqualToSize(size, self.cacheBg.size)) {
        return self.cacheBg;
    }
    CGFloat linearGradient1Locations[] = {0, 0.36, 1};
    UIImage *image =
    [self drawGradientBarWithSize:size
          linearGradientLocations:linearGradient1Locations
                           colors:@[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                                    (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor,
                                    (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                           ]
     ];
    self.cacheBg = image;
    return image;
}

- (UIImage *)gradientBarBg_landscape {
    CGSize size = CGSizeMake(self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    if (self.cacheBgLandscape && CGSizeEqualToSize(size, self.cacheBgLandscape.size)) {
        return self.cacheBgLandscape;
    }
    CGFloat linearGradient1Locations[] = {0, 0.5, 1};
    UIImage *image =
    [self drawGradientBarWithSize:size
          linearGradientLocations:linearGradient1Locations
                           colors:@[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                                    (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15].CGColor,
                                    (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                           ]
     ];
    self.cacheBgLandscape = image;
    return image;
}

- (UIImage *)drawGradientBarWithSize:(CGSize)size
             linearGradientLocations:(CGFloat[])linearGradientLocations
                              colors:(NSArray *)colors
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        UIBezierPath *gradientBarBgPath = [UIBezierPath bezierPathWithRect:rect];
        [gradientBarBgPath
         rg_drawLinearGradient:context
         colors:colors
         locations:linearGradientLocations
         startPoint:CGPointMake(0, rect.size.height)
         endPoint:CGPointMake(0, 0)];
    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end


@implementation UIViewController (RGNavigationController)

- (RGNavigationController *)rg_navigationController {
    if (self.navigationController) {
        if ([self.navigationController isKindOfClass:RGNavigationController.class]) {
            return (RGNavigationController *)self.navigationController;
        }
    }
    return nil;
}

- (__kindof UIViewController *(^)(UIViewController *))rg_pushedBy {
    return ^(UIViewController *nvg) {
        if (![nvg isKindOfClass:UINavigationController.class]) {
            nvg = nvg.navigationController;
        }
        [(UINavigationController *)nvg pushViewController:self animated:YES];
        return self;
    };
}

- (__kindof UIViewController *(^)(void))rg_hidesBottomBarWhenPushed {
    return ^ {
        self.hidesBottomBarWhenPushed = YES;
        return self;
    };
}

@end
