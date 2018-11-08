//
//  UIView+Layout.m
//  JusTalk
//
//  Created by juphoon on 2017/12/22.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIView+RGLayoutHelp.h"

@implementation UIView (RGLayoutHelp)

- (BOOL)rg_layoutLeftToRight {
    if (@available(iOS 9.0, *)) {
        return ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionLeftToRight);
    } else {
        return ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight);
    }
}

- (void)rg_setRTLFrame:(CGRect)frame width:(CGFloat)width {
    CGFloat x = width - frame.origin.x - frame.size.width;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)rg_setRTLFrame:(CGRect)frame {
    [self rg_setRTLFrame:frame width:self.superview.frame.size.width];
}

- (void)rg_setFrameToFitRTL {
    [self rg_setRTLFrame:self.frame];
}

@end


@implementation UIImage (RGLayoutHelp)

- (UIImage *)rg_imageFlippedForRightToLeftLayoutDirection {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end
