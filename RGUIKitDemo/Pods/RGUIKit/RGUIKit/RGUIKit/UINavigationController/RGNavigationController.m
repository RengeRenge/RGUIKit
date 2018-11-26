//
//  RGNavigationController.m
//  CampTalk
//
//  Created by kikilee on 2018/4/20.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import "RGNavigationController.h"
#import "UIBezierPath+RGDraw.h"
#import "UIViewController+RGBarFrame.h"

@interface RGNavigationController ()

@end

@implementation RGNavigationController

+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root {
    return [self navigationWithRoot:root style:0];
}

+ (RGNavigationController *)navigationWithRoot:(UIViewController *)root style:(RGNavigationBackgroundStyle)style {
    RGNavigationController *ngv = [[RGNavigationController alloc] initWithRootViewController:root];
    ngv.barBackgroundStyle = style;
    return ngv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
    [self performSelector:@selector(configBar) withObject:nil afterDelay:0.f inModes:@[NSRunLoopCommonModes]];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.navigationBar.tintColor = tintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : self.navigationBar.tintColor};
}

- (void)setBarBackgroundStyle:(RGNavigationBackgroundStyle)barBackgroundStyle {
    _barBackgroundStyle = barBackgroundStyle;
    if (self.isViewLoaded) {
        [self configBar];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(configBar) object:nil];
        [self performSelector:@selector(configBar) withObject:nil afterDelay:0.f inModes:@[NSRunLoopCommonModes]];
    }
}

//- (void)setBarStyle:(UIStatusBarStyle)barStyle {
//    _barStyle = barStyle;
//    [self setNeedsStatusBarAppearanceUpdate];
//}

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
            UIImage *barBg = nil;
            if ([UIViewController rg_isFringeScreen]) {
                barBg = self.gradientBarBg_fringe;
            } else {
                barBg = self.gradientBarBg;
            }
            [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsDefault];
            
            barBg = self.gradientBarBg_landscape;
            [self.navigationBar setBackgroundImage:barBg forBarMetrics:UIBarMetricsCompact];
            [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompactPrompt];
            break;
        }
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *topViewController = self.topViewController;
    while (topViewController.presentedViewController) {
        if (topViewController.presentedViewController.isBeingDismissed) {
            break;
        }
        topViewController = topViewController.presentedViewController;
    }
    return [topViewController preferredStatusBarStyle];
}

#pragma mark - draw image

- (UIImage *)gradientBarBg {
    CGFloat linearGradient1Locations[] = {0, 0.36, 1};
    UIImage *image =
    [self drawGradientBarWithHeight:64
            linearGradientLocations:linearGradient1Locations
                             colors:@[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                                      ]
     ];
    return image;
}

- (UIImage *)gradientBarBg_fringe {
    CGFloat linearGradient1Locations[] = {0, 0.36, 1};
    UIImage *image =
    [self drawGradientBarWithHeight:88
            linearGradientLocations:linearGradient1Locations
                             colors:@[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                                      ]
     ];
    return image;
}

- (UIImage *)gradientBarBg_landscape {
    CGFloat linearGradient1Locations[] = {0, 0.5, 1};
    UIImage *image =
    [self drawGradientBarWithHeight:32
            linearGradientLocations:linearGradient1Locations
                             colors:@[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15].CGColor,
                                      (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                                      ]
     ];
    return image;
}

- (UIImage *)drawGradientBarWithHeight:(CGFloat)height
               linearGradientLocations:(CGFloat[])linearGradientLocations
                                colors:(NSArray *)colors
{
    CGRect rect = CGRectMake(0, 0, self.navigationBar.frame.size.width, height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        UIBezierPath *gradientBarBgPath = [UIBezierPath bezierPathWithRect:rect];
        [gradientBarBgPath
         rg_drawLinearGradient:context
         locations:linearGradientLocations
         colors:colors
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

@end
