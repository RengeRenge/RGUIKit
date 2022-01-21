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

+ (UIColor *_Nullable)rg_colorWithRGBHexString:(NSString *_Nullable)hexString {
    if (!hexString.length) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor rg_colorWithRGBHex:hexNum];
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

+ (UIColor *)rg_colorInLinearGradientColorStart:(UIColor *)colorStart colorEnd:(UIColor *)colorEnd colorLocation:(NSNumber *)colorLocation {
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    CGFloat a1;
    [colorStart getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    CGFloat r2;
    CGFloat g2;
    CGFloat b2;
    CGFloat a2;
    [colorEnd getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    CGFloat p = MIN(colorLocation.floatValue, 1.f);
    return [UIColor colorWithRed:r1 + (r2 - r1) * p
                           green:g1 + (g2 - g1) * p
                            blue:b1 + (b2 - b1) * p
                           alpha:a1 + (a2 - a1) * p];
}

+ (UIColor *)rg_colorInLinearGradientColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations colorLocation:(NSNumber *)colorLocation {
    if (colors.count == 0) {
        return nil;
    }
    if (colors.count == 1) {
        return colors.firstObject;
    }
    
    CGFloat percent = MIN(colorLocation.floatValue, 1.f);
    
    __block NSUInteger s = 0;
    NSUInteger e = 0;
    CGFloat p = 0;
    if (locations) {
        [locations enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.floatValue < percent) {
                s = idx;
            } else if (obj.floatValue == percent) {
                s = idx;
                *stop = YES;
            } else {
                *stop = YES;
            }
        }];
        e = MIN(s + 1, locations.count - 1);
        if (e < locations.count && e != s) {
            CGFloat l = locations[e].floatValue - locations[s].floatValue;
            p = (percent - locations[s].floatValue) / l;
        }
    } else {
        s = floor(percent * (colors.count - 1));
        s = MIN(s, colors.count - 1);
        
        e = MIN(s + 1, colors.count - 1);
        
        CGFloat l = 1.f / (colors.count - 1);
        p = (percent - s * l) / l;;
    }
//    NSLog(@"s:%lu, e:%lu, p:%f", (unsigned long)s, (unsigned long)e, p);
    if (s < colors.count && e < colors.count) {
        p = MIN(1, MAX(0, p));
        return [self rg_colorInLinearGradientColorStart:colors[s] colorEnd:colors[e] colorLocation:@(p)];
    }
    return nil;
}

- (UIColor *)rg_coverOnColor:(UIColor *)backgroundColor {
    CGFloat r1;
    CGFloat g1;
    CGFloat b1;
    CGFloat a1;
    [backgroundColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    CGFloat r2;
    CGFloat g2;
    CGFloat b2;
    CGFloat a2;
    [self getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    return [UIColor colorWithRed:[UIColor _blendWithA1:a1 a2:a2 c1:r1 c2:r2]
                           green:[UIColor _blendWithA1:a1 a2:a2 c1:g1 c2:g2]
                            blue:[UIColor _blendWithA1:a1 a2:a2 c1:b1 c2:b2]
                           alpha:a1 + a2 - a1 * a2];
}

+ (CGFloat)_blendWithA1:(CGFloat)a1 a2:(CGFloat)a2 c1:(CGFloat)c1 c2:(CGFloat)c2 {
    return (c1 * a1 * (1.0 - a2) + c2 * a2) / (a1 + a2 - a1 * a2);
}

@end

@implementation UIColor(RGDynamic)

+ (UIColor *)rg_colorWithDynamicProvider:(UIColor * _Nonnull (^)(BOOL))dynamicProvider {
    if (@available(iOS 13, *)) {
        return [self colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return dynamicProvider([traitCollection userInterfaceStyle] == UIUserInterfaceStyleDark);
        }];
    } else {
        return dynamicProvider(NO);
    }
}

+ (UIColor *)rg_systemBackgroundColor {
    if (@available(iOS 13, *)) {
        return self.systemBackgroundColor;
    } else {
        return self.whiteColor;
    }
}

+ (UIColor *)rg_secondarySystemBackgroundColor {
    if (@available(iOS 13, *)) {
        return [self secondarySystemBackgroundColor];
    } else {
        return [self colorWithRed:0.95 green:0.95 blue:0.97 alpha:1];
    }
}

+ (UIColor *)rg_secondarySystemGroupedBackgroundColor {
    if (@available(iOS 13, *)) {
        return [self secondarySystemGroupedBackgroundColor];
    } else {
        return [self whiteColor];
    }
}

+ (UIColor *)rg_systemGroupedBackgroundColor {
    if (@available(iOS 13, *)) {
        return self.systemGroupedBackgroundColor;
    } else {
        return [self groupTableViewBackgroundColor];
    }
}

+ (UIColor *)rg_separatorColor {
    if (@available(iOS 13, *)) {
        return self.separatorColor;
    } else {
        return [self colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.29];
    }
}

+ (UIColor *)rg_labelColor {
    if (@available(iOS 13, *)) {
        return self.labelColor;
    } else {
        return self.darkTextColor;
    }
}

+ (UIColor *)rg_secondaryLabelColor {
    if (@available(iOS 13, *)) {
        return self.secondaryLabelColor;
    } else {
        return [self colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.6];
    }
}

+ (UIColor *)rg_placeholderTextColor {
    if (@available(iOS 13, *)) {
        return self.placeholderTextColor;
    } else {
        return [self colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.3];
    }
}

+ (UIColor *)rg_tableCellGroupedBackgroundColor {
    return [UIColor rg_colorWithDynamicProvider:^UIColor * _Nonnull(BOOL dark) {
        return dark ? [self colorWithRed:0.11 green:0.11 blue:0.12 alpha:1] : [UIColor colorWithWhite:1 alpha:1];
    }];
}

+ (UIColor *)rg_tertiarySystemFillColor {
    return [UIColor rg_colorWithDynamicProvider:^UIColor * _Nonnull(BOOL dark) {
        return dark ? [self colorWithRed:0.46 green:0.46 blue:0.5 alpha:0.24] : [self colorWithRed:0.46 green:0.46 blue:0.5 alpha:0.12];
    }];
}

@end
