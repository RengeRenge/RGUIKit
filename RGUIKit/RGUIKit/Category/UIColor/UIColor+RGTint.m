//
//  UIColor+RGTint.m
//  Pods
//
//  Created by renge on 2019/8/1.
//

#import "UIColor+RGTint.h"

@implementation UIColor(RGTint)

- (BOOL)rg_isDarkColor {
    CGFloat r=0,g=0,b=0,a=0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor rg_isDarkColorForR:r*255 g:g*255 b:b*255];
}

+ (BOOL)rg_isDarkColorForR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    if(red*0.299 + green*0.578 + blue*0.114 >= 192){ //浅色
        return NO;
    } else {  //深色
        return YES;
    }
}

@end
