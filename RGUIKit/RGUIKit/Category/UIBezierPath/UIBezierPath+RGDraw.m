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

@interface RGGradientObsever : NSObject

@property (nonatomic, copy) NSArray *rg_drawColors;
@property (nonatomic, assign) RGDrawType rg_drawType;
@property (nonatomic, assign) CGFloat rg_drawRad;
@property (nonatomic, assign) BOOL rg_isDrawRad;
@property (nonatomic, strong, nullable) NSArray <NSNumber *> *rg_drawLocations;
@property (nonatomic, strong, nullable) UIBezierPath *rg_drawPath;
@property (nonatomic, assign) CGRect bounds;

@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign) BOOL rg_isDrawObsever;

@end

@interface UIView (RGGradientParam)

@property (nonatomic, strong) RGGradientObsever *rg_gradientObsever;
@property (nonatomic, strong) NSNumber *rg_gradientId;

@end

@implementation UIView (RGGradientParam)

- (void)setRg_gradientObsever:(RGGradientObsever *)rg_gradientObsever {
    [self rg_setValue:rg_gradientObsever forConstKey:"_rg_gradientObsever" retain:YES];
}

- (RGGradientObsever *)rg_gradientObsever {
    return [self rg_valueforConstKey:"_rg_gradientObsever"];
}

- (void)setRg_gradientId:(NSNumber *)rg_gradientId {
    [self rg_setValue:rg_gradientId forConstKey:"_rg_gradientId" retain:YES];
}

- (NSNumber *)rg_gradientId {
    return [self rg_valueforConstKey:"_rg_gradientId"];
}

@end

@implementation RGGradientObsever

+ (void)addObserverWithView:(UIView *)view
                     colors:(NSArray <id> *)colors
                  locations:(NSArray <NSNumber *> *)locations
                       path:(UIBezierPath *)path
                   drawType:(RGDrawType)drawType
                    drawRad:(CGFloat)rad
                  isDrawRad:(BOOL)isDrawRad {
    RGGradientObsever *ob = view.rg_gradientObsever;
    if (!ob) {
        ob = [RGGradientObsever new];
        view.rg_gradientObsever = ob;
        [view rg_addObserver:ob forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@"RGGradientColors"];
    }
    
    ob.rg_drawColors = colors;
    ob.rg_drawLocations = locations;
    ob.rg_drawPath = path;
    ob.rg_drawType = drawType;
    ob.rg_drawRad = rad;
    ob.rg_isDrawRad = isDrawRad;
    ob.bounds = view.bounds;
    ob.view = view;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context && [@"RGGradientColors" isEqualToString:(__bridge NSString * _Nonnull)(context)]) {
        UIView *view = object;
        if (view != self.view || CGSizeEqualToSize(self.bounds.size, view.bounds.size)) {
            return;
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reDraw) object:nil];
        [self performSelector:@selector(reDraw) withObject:nil afterDelay:0];
    }
}

- (void)reDraw {
    if (CGSizeEqualToSize(self.bounds.size, self.view.bounds.size)) {
        return;
    }
    self.bounds = self.view.bounds;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reDraw) object:nil];
    if (self.rg_isDrawRad) {
        [self.view rg_setBackgroundGradientColors:self.rg_drawColors locations:self.rg_drawLocations path:self.rg_drawPath drawRad:self.rg_drawRad];
    } else {
        [self.view rg_setBackgroundGradientColors:self.rg_drawColors locations:self.rg_drawLocations path:self.rg_drawPath drawType:self.rg_drawType];
    }
}

@end

static RGGradientObsever *_rg_gradient_obsever;

#define kDrawByContext YES

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
        case RGDrawTypeLeftToRight:{
            [self rg_gradientParamWithBounds:bounds rad:M_PI param:^(CGPoint sPonit, CGPoint ePonit) {
                param(sPonit, ePonit, NO, 0);
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

@implementation UIView (RGGradient)

- (CAGradientLayer *)rg_gradientLayer {
    CAGradientLayer *layer = [self rg_valueforConstKey:"_rg_gradientLayer"];
    if (!layer) {
        layer = [[CAGradientLayer alloc] init];
        [self rg_setValue:layer forConstKey:"_rg_gradientLayer" retain:YES];
        [self.layer insertSublayer:layer atIndex:0];
    }
    return layer;
}

- (CAShapeLayer *)shapeGradientLayer {
    CAShapeLayer *layer = [self rg_valueforConstKey:"_rg_shapeGradientLayer"];
    if (!layer) {
        layer = [[CAShapeLayer alloc] init];
        [self rg_setValue:layer forConstKey:"_rg_shapeGradientLayer" retain:YES];
    }
    return layer;
}

- (void)rg_setBackgroundGradientColors:(NSArray <id> *)colors
                             locations:(NSArray <NSNumber *> *)locations
                              drawType:(RGDrawType)drawType {
    [self rg_setBackgroundGradientColors:colors
                               locations:locations
                                    path:nil
                                drawType:drawType];
}

- (void)rg_setBackgroundGradientColors:(NSArray<id> *)colors
                             locations:(NSArray <NSNumber *> *)locations
                               drawRad:(CGFloat)rad {
    [self rg_setBackgroundGradientColors:colors
                               locations:locations
                                    path:nil
                                 drawRad:rad];
}

- (void)rg_setBackgroundGradientColors:(NSArray<id> *)colors
                             locations:(NSArray <NSNumber *> *)locations
                                  path:(UIBezierPath *)path
                              drawType:(RGDrawType)drawType {
    UIBezierPath *dPath = path;
    if (!dPath) {
        dPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    [RGGradientObsever addObserverWithView:self colors:colors locations:locations path:path drawType:drawType drawRad:0 isDrawRad:NO];
    
    CALayer *layer = self.rg_gradientLayer;
    
    if (kDrawByContext) {
        layer.frame = self.layer.bounds;
        NSUInteger count = locations.count;
        CGFloat *los = nil;
        if (count) {
            los = malloc(sizeof(CGFloat) * count);
            for (int i = 0; i < count; ++i) {
                CGFloat value = [locations[i] floatValue];
                los[i] = value;
            }
        }
        
        NSNumber *gradientId = @(arc4random());
        self.rg_gradientId = gradientId;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *img = nil;
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, [UIScreen mainScreen].scale);
            {
                CGContextRef gc = UIGraphicsGetCurrentContext();
                [dPath rg_drawGradient:gc colors:colors locations:los drawType:drawType];
                img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            if (los) {
                free(los);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.rg_gradientId != gradientId) {
                    return;
                }
                layer.contents = (__bridge id _Nullable)(img.CGImage);
            });
        });
        return;
    }
    
//    CGRect bounds = path.bounds;
//    layer.frame = bounds;
    
//    CGFloat side = MAX(bounds.size.height, bounds.size.width);
//    CGRect frame = CGRectMake
//    (self.layer.bounds.origin.x + (self.layer.bounds.size.width - side) / 2,
//     self.layer.bounds.origin.y + (self.layer.bounds.size.height - side) / 2,
//     side,
//     side);
//    layer.frame = frame;
    
//    bounds.origin = CGPointZero;
//    [self __rg_setBackgroundGradientColors:colors locations:nil drawType:drawType bounds:bounds];
    
//    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y);
//    [path applyTransform:transfrom];
//    self.shapeGradientLayer.path = CGPathCreateCopyByTransformingPath(path.CGPath, &transfrom);;
//    self.shapeGradientLayer.path = dPath.CGPath;
//    self.layer.mask = self.shapeGradientLayer;
//    self.rg_gradientLayer.mask = self.shapeGradientLayer;
}

- (void)rg_setBackgroundGradientColors:(NSArray<id> *)colors
                             locations:(NSArray <NSNumber *> *)locations
                                  path:(UIBezierPath *)path
                               drawRad:(CGFloat)rad {
    CALayer *layer = self.rg_gradientLayer;
    layer.frame = self.layer.bounds;
    
    UIBezierPath *dPath = path;
    if (!dPath) {
        dPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    [RGGradientObsever addObserverWithView:self colors:colors locations:locations path:path drawType:0 drawRad:rad isDrawRad:YES];
    
    CGFloat *los = nil;
    NSUInteger count = locations.count;
    if (count) {
        los = malloc(sizeof(CGFloat) * count);
        for (int i = 0; i < count; ++i) {
            CGFloat value = [locations[i] floatValue];
            los[i] = value;
        }
    }
    
    NSNumber *gradientId = @(arc4random());
    self.rg_gradientId = gradientId;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *img = nil;
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, [UIScreen mainScreen].scale);
        {
            CGContextRef gc = UIGraphicsGetCurrentContext();
            
            [dPath rg_drawLinearGradient:gc colors:colors locations:los drawRad:rad];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        if (los) {
            free(los);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.rg_gradientId != gradientId) {
                return;
            }
            layer.contents = (__bridge id _Nullable)(img.CGImage);
        });
    });
}

- (void)rg_removeBackgroundGradientColors {
    CALayer *layer = [self rg_valueforConstKey:"_rg_gradientLayer"];
    if (layer) {
        [layer removeFromSuperlayer];
        [self rg_setValue:nil forConstKey:"_rg_gradientLayer" retain:YES];
        [self rg_setValue:nil forConstKey:"_rg_shapeGradientLayer" retain:YES];
    }
}







/// unused
//- (void)__rg_setBackgroundGradientColors:(NSArray <id> *)colors
//                               locations:(NSArray<NSNumber *> *)locations
//                                drawType:(RGDrawType)drawType
//                                  bounds:(CGRect)bounds {
//    [NSObject rg_gradientParamWithBounds:bounds drawType:drawType param:^(CGPoint sPonit, CGPoint ePonit, BOOL circle, CGFloat radius) {
//
//        CAGradientLayer *layer = self.rg_gradientLayer;
//        layer.colors = colors.rg_CGColors;
//        layer.locations = locations;
//
//        CGSize layerSize = layer.frame.size;
//
//        sPonit.x = (sPonit.x)/layerSize.width;
//        sPonit.y = (sPonit.y)/layerSize.height;
//
//        ePonit.x = (ePonit.x)/layerSize.width;
//        ePonit.y = (ePonit.y)/layerSize.height;
//
//        layer.startPoint = sPonit;
//        layer.endPoint = ePonit;
//        layer.type = circle ? kCAGradientLayerRadial : kCAGradientLayerAxial;
//    }];
//}

@end
