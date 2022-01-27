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
#import "UIImage+RGTint.h"
#import <RGObserver/RGObserver.h>

void *RGNavigationControllerOBKey = "RGNavigationController";

@interface RGNavigationController ()

@property (nonatomic, strong) UIImage *cacheBg;
@property (nonatomic, strong) UIImage *cacheBgLandscape;

- (UIImage *)gradientBarBg;
- (UIImage *)gradientBarBg_landscape;

@end

@interface RGNavigationBarAppearance ()

@property (nonatomic, weak) RGNavigationController *navigationController;

@end

@implementation RGNavigationBarAppearance

- (UINavigationBar *)navigationBar {
    return self.navigationController.navigationBar;
}

- (UINavigationBarAppearance *)appearance  API_AVAILABLE(ios(13.0)) {
    return self == self.navigationController.standardAppearance ? self.navigationBar.standardAppearance : self.navigationBar.scrollEdgeAppearance;
}

- (UINavigationBarAppearance *)compactAppearance  API_AVAILABLE(ios(13.0)) {
    if (@available(iOS 15.0, *)) {
        return self == self.navigationController.standardAppearance ? self.navigationBar.compactAppearance : self.navigationBar.compactScrollEdgeAppearance;
    } else {
        return self == self.navigationController.standardAppearance ? self.navigationBar.compactAppearance : nil;
    }
}

- (void)setNavigationController:(RGNavigationController *)navigationController {
    _navigationController = navigationController;
    if (@available(iOS 13.0, *)) {
        if (self == self.navigationController.standardAppearance) {
            self.navigationBar.standardAppearance = [UINavigationBarAppearance new];
            self.navigationBar.compactAppearance = [UINavigationBarAppearance new];
        } else {
            self.navigationBar.scrollEdgeAppearance = [UINavigationBarAppearance new];
            if (@available(iOS 15.0, *)) {
                self.navigationBar.compactScrollEdgeAppearance = [UINavigationBarAppearance new];
            }
        }
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    [self setTitleColor:titleColor withTint:NO];
}

- (void)setTitleColor:(UIColor *)titleColor withTint:(BOOL)withTint {
    if (!withTint) {
        _titleColor = titleColor;
    }
    
    if (!self.enabled) {
        return;
    }
    
    NSDictionary *titleTextAttributes = nil;
    if (titleColor) {
        titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};
    } else {
        titleTextAttributes = @{NSForegroundColorAttributeName : self.navigationBar.tintColor};
    }
    
    if (@available(iOS 13.0, *)) {
        self.appearance.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};
        self.compactAppearance.titleTextAttributes = @{NSForegroundColorAttributeName : titleColor};
    } else {
        self.navigationBar.titleTextAttributes = titleTextAttributes;
    }
}

- (void)setHideSeparator:(BOOL)hideSeparator {
    if (hideSeparator == _hideSeparator) {
        return;
    }
    _hideSeparator = hideSeparator;
    [self performConfigBar];
}

- (void)setBarBackgroundStyle:(RGNavigationBackgroundStyle)barBackgroundStyle {
    if (barBackgroundStyle == _barBackgroundStyle) {
        return;
    }
    _barBackgroundStyle = barBackgroundStyle;
    [self performConfigBar];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if ([_backgroundColor isEqual:backgroundColor]) {
        return;
    }
    _backgroundColor = backgroundColor;
    [self performConfigBar];
}

- (void)performConfigBar {
    if (self.navigationController.isViewLoaded) {
        [self configBar];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
        [self performSelector:@selector(configBar) withObject:nil afterDelay:0.f inModes:@[NSRunLoopCommonModes]];
    }
}

- (BOOL)enabled {
    if (self == self.navigationController.scrollEdgeAppearance) {
        if (@available(iOS 13.0, *)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

- (void)configBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
    
    if (!self.enabled) {
        return;
    }
    
    switch (_barBackgroundStyle) {
        case RGNavigationBackgroundStyleNormal:{
            [self.navigationBar setTranslucent:YES];
            
            UIImage *image = nil;
            if (self.backgroundColor) {
                image = [UIImage rg_coloredImage:self.backgroundColor size:CGSizeMake(1, 1)];
            }
            if (@available(iOS 13.0, *)) {
                [self.appearance configureWithDefaultBackground];
                [self.compactAppearance configureWithDefaultBackground];
                
                self.appearance.backgroundImage = image;
                self.compactAppearance.backgroundImage = image;
                if (image) {
                    self.appearance.backgroundEffect = nil;
                    self.compactAppearance.backgroundEffect = nil;
                }
                
            } else {
                [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompact];
                [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsCompactPrompt];
            }
            
            UIImage *shadowImage = _hideSeparator ? UIImage.new : nil;
            if (@available(iOS 13.0, *)) {
                self.appearance.shadowImage = shadowImage;
            } else {
                [self.navigationBar setShadowImage:shadowImage];
            }
            break;
        }
        case RGNavigationBackgroundStyleAllTranslucent: {
            [self.navigationBar setTranslucent:YES];
            
            if (@available(iOS 13.0, *)) {
                [self.appearance configureWithTransparentBackground];
                [self.compactAppearance configureWithTransparentBackground];
            } else {
                UIImage *barBg = [UIImage new];
                [self.navigationBar setShadowImage:barBg];
                [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsCompact];
                [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsCompactPrompt];
            }
            break;
        }
        case RGNavigationBackgroundStyleShadow: {
            [self.navigationBar setTranslucent:YES];
            if (@available(iOS 13.0, *)) {
                [self.appearance configureWithTransparentBackground];
                [self.compactAppearance configureWithTransparentBackground];
                
                self.appearance.backgroundImage = self.navigationController.gradientBarBg;
                self.compactAppearance.backgroundImage = self.navigationController.gradientBarBg_landscape;
            } else {
                [self.navigationBar setShadowImage:[UIImage new]];
                [self.navigationBar setBackgroundImage:self.navigationController.gradientBarBg forBarMetrics:UIBarMetricsDefault];
                [self.navigationBar setBackgroundImage:self.navigationController.gradientBarBg_landscape forBarMetrics:UIBarMetricsCompact];
                [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompactPrompt];
            }
            break;
        }
        default:
            break;
    }
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
}

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
    
    self.scrollEdgeAppearance = [RGNavigationBarAppearance new];
    self.standardAppearance = [RGNavigationBarAppearance new];
    
    self.scrollEdgeAppearance.navigationController = self;
    self.standardAppearance.navigationController = self;
    
    self.scrollEdgeAppearance.barBackgroundStyle = RGNavigationBackgroundStyleAllTranslucent;
    [self performConfigBar];
    
    [self.navigationBar rg_addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:RGNavigationControllerOBKey];
    [self.navigationBar rg_addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:RGNavigationControllerOBKey];
}

#pragma mark - Setter

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.navigationBar.tintColor = tintColor;
    
    if (!self.standardAppearance.titleColor) {
        [self.standardAppearance setTitleColor:tintColor withTint:YES];
    }
    if (!self.scrollEdgeAppearance.titleColor) {
        [self.scrollEdgeAppearance setTitleColor:tintColor withTint:YES];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.standardAppearance.titleColor = titleColor;
    if (self.scrollEdgeKeepPaceWithStandard) {
        self.scrollEdgeAppearance.titleColor = titleColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.standardAppearance.backgroundColor = backgroundColor;
    if (self.scrollEdgeKeepPaceWithStandard) {
        self.scrollEdgeAppearance.backgroundColor = backgroundColor;
    }
}

- (void)setBarBackgroundStyle:(RGNavigationBackgroundStyle)barBackgroundStyle {
    _barBackgroundStyle = barBackgroundStyle;
    self.standardAppearance.barBackgroundStyle = barBackgroundStyle;
    if (self.scrollEdgeKeepPaceWithStandard) {
        self.scrollEdgeAppearance.barBackgroundStyle = barBackgroundStyle;
    }
}

- (void)setHideSeparator:(BOOL)hideSeparator {
    _hideSeparator = hideSeparator;
    self.standardAppearance.hideSeparator = hideSeparator;
    if (self.scrollEdgeKeepPaceWithStandard) {
        self.scrollEdgeAppearance.hideSeparator = hideSeparator;
    }
}

#pragma mark - Universal Setter

- (CGFloat)barBackgroundAlpha {
    return self.navigationBar.rg_backgroundAlpha;
}

- (void)setBarBackgroundAlpha:(CGFloat)barBackgroundAlpha {
    self.navigationBar.rg_backgroundAlpha = barBackgroundAlpha;
}

- (void)performConfigBar {
    [self.standardAppearance performConfigBar];
    [self.scrollEdgeAppearance performConfigBar];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (RGNavigationControllerOBKey == context) {
        [self performConfigBar];
    }
}

#pragma mark - Life Cycle

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self performConfigBar];
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
