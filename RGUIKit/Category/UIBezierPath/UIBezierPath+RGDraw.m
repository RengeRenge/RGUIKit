//
//  UIBezierPath+RGDraw.m
//  RGUIKit
//
//  Created by renge on 2018/11/8.
//  Copyright © 2018 ld. All rights reserved.
//

#import "UIBezierPath+RGDraw.h"

@implementation UIBezierPath (RGDraw)

- (void)rg_drawLinearGradient:(CGContextRef)context
                    locations:(CGFloat [])locations
                       colors:(NSArray<UIColor *> *)colors
                     drawType:(RGUIBezierDrawType)drawType
{
    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds)) {
        return;
    }
    CGPoint sPonit = CGPointZero;
    CGPoint ePonit = CGPointZero;
    BOOL circle = NO;
    
    switch (drawType) {
            case RGUIBezierDrawTypeLTR:
            sPonit = CGPointMake(0, 0);
            ePonit = CGPointMake(CGRectGetMaxX(bounds), 0);
            break;
            case RGUIBezierDrawTypeUTD:
            sPonit = CGPointMake(0, 0);
            ePonit = CGPointMake(0, CGRectGetMaxY(bounds));
            break;
            case RGUIBezierDrawTypeLUTRD45: {
                CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
                CGFloat radius = sqrt(pow(bounds.size.width / 2.0, 2) + pow(bounds.size.height / 2.0, 2));
                CGFloat offset = radius / sqrt(2);
                sPonit.x = center.x - offset;
                sPonit.y = center.y - offset;
                ePonit.x = center.x + offset;
                ePonit.y = center.y + offset;
                break;
            }
            case RGUIBezierDrawTypeDiagonal:
            sPonit = CGPointMake(0, 0);
            ePonit = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            break;
            case RGUIBezierDrawTypeCircleFit:
            case RGUIBezierDrawTypeCircleFill:
            circle = YES;
            sPonit = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidX(bounds));
            break;
        default:
            return;
    }
    
    if (circle) {
        CGFloat radius;
        if (drawType == RGUIBezierDrawTypeCircleFit) {
            radius = MIN(bounds.size.width, bounds.size.height) / 2.f;
        } else {
            radius = MAX(bounds.size.width, bounds.size.height) / 2.f * sqrt(2);
        }
        [self rg_drawRadialGradient:context locations:locations colors:colors center:sPonit radius:radius];
    } else {
        [self rg_drawLinearGradient:context locations:locations colors:colors startPoint:sPonit endPoint:ePonit];
    }
}

- (void)rg_drawLinearGradient:(CGContextRef)context
                    locations:(CGFloat [])locations
                       colors:(NSArray<id> *)colors
                   startPoint:(CGPoint)startPoint
                     endPoint:(CGPoint)endPoint
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if ([colors.firstObject isKindOfClass:UIColor.class]) {
        colors = colors.rg_CGColors;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGContextSaveGState(context);
//    CGContextAddPath(context, self.CGPath);
//    CGContextClip(context);
    [self addClip];
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)rg_drawRadialGradient:(CGContextRef)context
                    locations:(CGFloat [])locations
                       colors:(NSArray<id> *)colors
                       center:(CGPoint)center
                       radius:(CGFloat)radius
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if ([colors.firstObject isKindOfClass:UIColor.class]) {
        colors = colors.rg_CGColors;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGContextSaveGState(context);
//    CGContextAddPath(context, self.CGPath);
//    CGContextEOClip(context);
    [self addClip];
    CGContextDrawRadialGradient(context, gradient,
                                center, 0,
                                center, radius,
                                0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end

@implementation NSArray (RGGradientColors)

- (NSMutableArray *)rg_CGColors {
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UIColor.class]) {
            [cgColors addObject:(__bridge id)[obj CGColor]];
        }
    }];
    return cgColors;
}

@end
