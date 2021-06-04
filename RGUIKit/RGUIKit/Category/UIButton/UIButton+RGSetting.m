//
//  UIButton+RGSetting.m
//  RGUIKit
//
//  Created by renge on 2021/6/2.
//

#import "UIButton+RGSetting.h"

@implementation UIButton(RGSetting)

- (void)rg_setTitle:(NSString *)title forState:(UIControlState)state animated:(BOOL)animated {
    if (animated) {
        [self setTitle:title forState:state];
        return;
    }
    if (self.buttonType == UIButtonTypeSystem) {
        [UIView performWithoutAnimation:^{
          [self setTitle:title forState:state];
          [self layoutIfNeeded];
        }];
    } else {
        [UIView setAnimationsEnabled:NO];
        [self setTitle:title forState:state];
        [self layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

@end
