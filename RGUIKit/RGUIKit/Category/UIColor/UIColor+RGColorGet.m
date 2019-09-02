//
//  UIColor+RGColorGet.m
//  Pods-RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//

#import "UIColor+RGColorGet.h"

@implementation UIColor(RGColorGet)

+ (UIColor *)rg_randomColor {
    return [UIColor colorWithRed:arc4random()%256 / 255.f green:arc4random()%256 / 255.f blue:arc4random()%256 / 255.f alpha:1.f];
}

+ (UIColor *)rg_colorWithRGBA:(double)R, ... {
    if (R) {
        
        va_list args;
        va_start(args, R);
        
        CGFloat rgba[4] = {1,1,1,1};
        int i = 0;
        
        double arg = R;
        
        do {
            if (i < 3) {
                rgba[i] = arg / 255.f;
            } else {
                rgba[i] = arg;
                break;
            }
            i++;
        } while ((arg = va_arg(args, double)));
        
        va_end(args);
        return [UIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
    }
    return [UIColor new];
}

+ (UIColor *)rg_colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (UIColor *)rg_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

@end
