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

- (CGPoint)rg_centerInSuperView {
    CGPoint point = RG_CGSelfCenter(self.frame);
    CGRect bounds = self.superview.bounds;
    point.x += bounds.origin.x;
    point.x += bounds.origin.y;
    return point;
}

- (CGPoint)rg_centerInSuperViewOriginZero {
    return RG_CGSelfCenter(self.frame);
}

- (CGFloat)rg_top {
    return self.frame.origin.y;
}

- (CGFloat)rg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)rg_leading {
    if (self.rg_layoutLeftToRight) {
        return self.frame.origin.x;
    }
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)rg_trailing {
    if (self.rg_layoutLeftToRight) {
        return self.frame.origin.x + self.frame.size.width;
    }
    return self.frame.origin.x;
}

- (CGFloat)rg_leadingForBounds {
    if (self.rg_layoutLeftToRight) {
        return self.bounds.origin.x;
    }
    return self.bounds.origin.x + self.bounds.size.width;
}

- (CGFloat)rg_trailingForBounds {
    if (self.rg_layoutLeftToRight) {
        return self.bounds.origin.x + self.bounds.size.width;
    }
    return self.bounds.origin.x;
}

- (CGSize)rg_size {
    return self.frame.size;
}

- (CGFloat)rg_width {
    return self.frame.size.width;
}

- (CGFloat)rg_height {
    return self.frame.size.height;
}

@end


@implementation UIImage (RGLayoutHelp)

- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end

CGPoint RG_CGSelfCenter(CGRect frame) {
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}

CGRect RG_CGRectMake(CGPoint center, CGSize size) {
    return CGRectMake(center.x, center.y, size.width, size.height);
}

CGFloat RG_Flat(CGFloat value) {
    if (value == FLT_MIN) {
        value = 0;
    }
    NSUInteger newScale = UIScreen.mainScreen.scale;
    return ceil(value * newScale) / newScale;
}

CGRect RG_CGRectMakeFlat(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(RG_Flat(x), RG_Flat(y), RG_Flat(width), RG_Flat(height));
}

CGRect RG_CGRectFlat(CGRect frame) {
    return RG_CGRectMakeFlat(
                             frame.origin.x,
                             frame.origin.y,
                             frame.size.width,
                             frame.size.height
                             );
}
