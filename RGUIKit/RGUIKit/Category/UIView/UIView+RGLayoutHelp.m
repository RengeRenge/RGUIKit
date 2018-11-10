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
    [UITabBar appearance].semanticContentAttribute = semanticContentAttribute;
    [UISearchBar appearance].semanticContentAttribute = semanticContentAttribute;
    [UITextField appearance].semanticContentAttribute = semanticContentAttribute;
    [UITextView appearance].semanticContentAttribute = semanticContentAttribute;
    [UITableViewCell appearance].semanticContentAttribute = semanticContentAttribute;
    [UINavigationBar appearance].semanticContentAttribute = semanticContentAttribute;
    
    UIViewController *topVc = [UIViewController rg_topViewController];
    topVc.view.semanticContentAttribute = semanticContentAttribute;
    topVc.tabBarController.tabBar.semanticContentAttribute = semanticContentAttribute;
    
    [topVc.view setNeedsLayout];
    [topVc.view setNeedsDisplay];
    [topVc.view setNeedsFocusUpdate];
    
    [topVc.navigationController rg_updateSemanticContentAttribute];
}

@end


@implementation UIImage (RGLayoutHelp)

- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end
