//
//  UITraitCollection+RGDark.m
//  RGUIKit
//
//  Created by renge on 2020/10/16.
//

#import "UITraitCollection+RGDark.h"

@implementation UITraitCollection(RGDark)

+ (BOOL)rg_isDark {
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return YES;
        }
    }
    return NO;
}

@end
