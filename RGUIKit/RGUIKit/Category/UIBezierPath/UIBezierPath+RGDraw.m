//
//  UIBezierPath+RGDraw.m
//  RGUIKit
//
//  Created by renge on 2018/11/8.
//  Copyright © 2018 ld. All rights reserved.
//

#import "UIBezierPath+RGDraw.h"
#import <RGUIKit/RGUIKit.h>
#import <RGRunTime/RGRunTime.h>
#import <RGObserver/RGObserver.h>

@implementation NSArray (RGGradientColors)

- (NSMutableArray *)rg_CGColors {
    NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:UIColor.class]) {
            [cgColors addObject:(__bridge id)[obj CGColor]];
        } else {
            [cgColors addObject:obj];
        }
    }];
    return cgColors;
}

@end

@implementation NSObject (RGGradientLocations)

+ (void)rg_transformNumberLocations:(NSArray <NSNumber *> *)loc toLocations:(void (NS_NOESCAPE^)(CGFloat * _Nonnull locations, void (^_Nonnull free)(void)))locations {
    NSUInteger count = loc.count;
    CGFloat *los = nil;
    if (count) {
        los = malloc(sizeof(CGFloat) * count);
        for (int i = 0; i < count; ++i) {
            CGFloat value = [loc[i] floatValue];
            los[i] = value;
        }
    }
    locations(los, ^{
        if (los) {
            free(los);
        }
    });
}

@end

@implementation UIImage (RGGradientImage)

+ (UIImage *)rg_gradientImageWithPath:(UIBezierPath *)path
                               colors:(NSArray <id> *)colors
                            locations:(NSArray <NSNumber *> *_Nullable)locations
                             drawType:(RGDrawType)drawType {
    return [self __getCurrentContextWithPath:path context:^(CGContextRef gc) {
        [NSObject rg_transformNumberLocations:locations toLocations:^(CGFloat * _Nonnull locations, void (^ _Nonnull free)(void)) {
            [path rg_drawGradient:gc colors:colors locations:locations drawType:drawType];
            free();
        }];
    }];
}

+ (UIImage *)rg_gradientImageWithPath:(UIBezierPath *)path
                               colors:(NSArray <id> *)colors
                            locations:(NSArray <NSNumber *> *_Nullable)locations
                              drawRad:(CGFloat)rad {
    return [self __getCurrentContextWithPath:path context:^(CGContextRef gc) {
        [NSObject rg_transformNumberLocations:locations toLocations:^(CGFloat * _Nonnull locations, void (^ _Nonnull free)(void)) {
            [path rg_drawLinearGradient:gc colors:colors locations:locations drawRad:rad];
            free();
        }];
    }];
}

+ (UIImage *)__getCurrentContextWithPath:(UIBezierPath *)path context:(void(NS_NOESCAPE^)(CGContextRef gc))context {
    UIGraphicsBeginImageContextWithOptions(path.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    context(gc);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end

@implementation NSObject (RGCalGradientParam)

+ (void)rg_gradientParamWithBounds:(CGRect)bounds drawType:(RGDrawType)drawType param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit, BOOL circle, CGFloat radius))param {
    CGPoint sPonit = bounds.origin;
    CGPoint ePonit = CGPointZero;
    BOOL circle = NO;
    
    switch (drawType) {
        case RGDrawTypeTopToBottom:{
            [self rg_gradientParamWithBounds:bounds rad:M_PI_2 param:^(CGPoint sPonit, CGPoint ePonit) {
                param(sPonit, ePonit, NO, 0);
            }];
            return;
        }
        case RGDrawTypeLeadingToTrailing:
        case RGDrawTypeLeftToRight:{
            [self rg_gradientParamWithBounds:bounds rad:M_PI param:^(CGPoint sPonit, CGPoint ePonit) {
                param(sPonit, ePonit, NO, 0);
            }];
            return;
        }
        case RGDrawTypeRightToLeft: {
            [self rg_gradientParamWithBounds:bounds rad:M_PI param:^(CGPoint sPonit, CGPoint ePonit) {
                param(ePonit, sPonit, NO, 0);
            }];
            return;
        }
        case RGDrawTypeDiagonalTopRightToBottomLeft:
            sPonit = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            ePonit = CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            break;
        case RGDrawTypeDiagonalTopLeftToBottomRight:
            ePonit = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            break;
        case RGDrawTypeCircleFit:
        case RGDrawTypeCircleFill:
            circle = YES;
            sPonit = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
            ePonit = bounds.origin;
            break;
        default:
            return;
    }
    
    if (circle) {
        CGFloat radius;
        if (drawType == RGDrawTypeCircleFit) {
            radius = MIN(bounds.size.width, bounds.size.height) / 2.f;
        } else {
            radius = MAX(bounds.size.width, bounds.size.height) / 2.f;// * sqrt(2);
        }
        param(sPonit, ePonit, YES, radius);
    } else {
        param(sPonit, ePonit, NO, 0);
    }
}

+ (void)rg_gradientParamWithBounds:(CGRect)bounds
                               rad:(CGFloat)rad
                             param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit))param {
    CGPoint sPonit = bounds.origin;
    CGPoint ePonit = CGPointZero;

    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    /*
     **************
     fill
     **************
    CGFloat r = sqrt(pow(bounds.size.width / 2.0, 2) + pow(bounds.size.height / 2.0, 2));
    CGFloat offsetX = r * cos(rad);
    CGFloat offsetY = r * sin(rad);

    sPonit.x = center.x + offsetX;
    sPonit.y = center.y - offsetY;
    ePonit.x = center.x - offsetX;
    ePonit.y = center.y + offsetY;

    param(sPonit, ePonit);
    */
    
    CGFloat halfWidth = bounds.size.width / 2.f;
    CGFloat halfHeight = bounds.size.height / 2.f;
    
    CGFloat l = 0;
    if (sin(rad) == 0 || fabs(tan(rad) * halfWidth) < halfHeight) { // 相交与左右2边
        l = sqrt(pow(halfWidth, 2) + pow(tan(rad) * halfWidth, 2));
    } else {
        l = sqrt(pow(halfHeight, 2) + pow(halfHeight / tan(rad), 2));
    }
    sPonit.x = center.x + l * cos(rad);
    sPonit.y = center.y - l * sin(rad);
    
    ePonit.x = center.x - l * cos(rad);
    ePonit.y = center.y + l * sin(rad);
    
    param(sPonit, ePonit);
}

@end

@implementation UIBezierPath (RGDraw)

- (void)rg_drawGradient:(CGContextRef)context
                 colors:(NSArray<UIColor *> *)colors
              locations:(CGFloat [])locations
               drawType:(RGDrawType)drawType {
    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds)) {
        return;
    }
    
    [NSObject rg_gradientParamWithBounds:bounds drawType:drawType param:^(CGPoint sPonit, CGPoint ePonit, BOOL circle, CGFloat radius) {
        if (circle) {
            [self rg_drawRadialGradient:context colors:colors locations:locations center:sPonit radius:radius];
        } else {
            [self rg_drawLinearGradient:context colors:colors locations:locations startPoint:sPonit endPoint:ePonit];
        }
    }];
}

- (void)rg_drawLinearGradient:(CGContextRef)context
                       colors:(NSArray<id> *)colors
                    locations:(CGFloat [])locations
                      drawRad:(CGFloat)rad {
    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds)) {
        return;
    }
    
    [NSObject rg_gradientParamWithBounds:bounds rad:rad param:^(CGPoint sPonit, CGPoint ePonit) {
        [self rg_drawLinearGradient:context colors:colors locations:locations startPoint:sPonit endPoint:ePonit];
    }];
}

- (void)rg_drawLinearGradient:(CGContextRef)context
                       colors:(NSArray<id> *)colors
                    locations:(CGFloat [])locations

                   startPoint:(CGPoint)startPoint
                     endPoint:(CGPoint)endPoint {
//    CGContextSetShouldAntialias(context, YES);
//    CGContextSetAllowsAntialiasing(context, YES);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if ([colors.firstObject isKindOfClass:UIColor.class]) {
        colors = colors.rg_CGColors;
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGContextSaveGState(context);
    //    CGContextAddPath(context, self.CGPath);
    //    CGContextClip(context);
    [self addClip];
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)rg_drawRadialGradient:(CGContextRef)context
                       colors:(NSArray<id> *)colors
                    locations:(CGFloat [])locations

                       center:(CGPoint)center
                       radius:(CGFloat)radius {
//    CGContextSetShouldAntialias(context, YES);
//    CGContextSetAllowsAntialiasing(context, YES);
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
                                kCGGradientDrawsBeforeStartLocation|kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
