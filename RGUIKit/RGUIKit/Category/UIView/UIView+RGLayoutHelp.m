//
//  UIView+Layout.m
//  JusTalk
//
//  Created by juphoon on 2017/12/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIView+RGLayoutHelp.h"
#import "UIViewController+RGPresent.h"
#import "UINavigationController+RGShouldPop.h"

@implementation UIView (RGLayoutHelp)

- (BOOL)rg_layoutLeftToRight {
    if (@available(iOS 9.0, *)) {
        return ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionLeftToRight);
    } else {
        return ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight);
    }
}

- (void)rg_setRTLFrame:(CGRect)frame width:(CGFloat)width {
    self.frame = [UIView rg_RTLFrameWithLTRFrame:frame superWidth:width];
}

+ (CGRect)rg_RTLFrameWithLTRFrame:(CGRect)frame superWidth:(CGFloat)width {
    CGFloat x = width - frame.origin.x - frame.size.width;
    frame.origin.x = x;
    return frame;
}

- (void)rg_setRTLFrame:(CGRect)frame {
    [self rg_setRTLFrame:frame width:self.superview.frame.size.width];
}

- (void)rg_setFrameToFitRTL {
    [self rg_setRTLFrame:self.frame];
}

+ (void)rg_setSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute {
    
    [UIView appearance].semanticContentAttribute = semanticContentAttribute;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
        UIViewController *vc = window.rootViewController;
        [self _semanticContentAttributeDidChange:vc];
    }
}

+ (void)_semanticContentAttributeDidChange:(UIViewController *)viewController {
    UIViewController *vc = viewController;
    if (vc) {
        [vc.view setNeedsLayout];
        if (vc.presentedViewController) {
            [self _semanticContentAttributeDidChange:vc.presentedViewController];
        }
        for (UIViewController *childVC in vc.childViewControllers) {
            if (!childVC.isViewLoaded) {
                continue;
            }
            [self _semanticContentAttributeDidChange:childVC];
        }
    }
}
}

@end


@implementation UIImage (RGLayoutHelp)

- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end
