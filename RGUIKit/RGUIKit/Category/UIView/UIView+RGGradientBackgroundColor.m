//
//  UIView+RGGradientBackgroundColor.m
//  RGUIKit
//
//  Created by renge on 2021/6/4.
//

#import "UIView+RGGradientBackgroundColor.h"
#import <RGRunTime/RGRunTime.h>
#import <RGObserver/RGObserver.h>
#import <RGUIKit/RGUIKit.h>

#define kDrawByContext YES

@interface RGGradientObsever : NSObject

@property (nonatomic, copy) NSArray *drawColors;
@property (nonatomic, assign) RGDrawType drawType;
@property (nonatomic, assign) CGFloat drawRad;
@property (nonatomic, assign) BOOL isDrawRad;
@property (nonatomic, strong, nullable) NSArray <NSNumber *> *drawLocations;
@property (nonatomic, strong, nullable) UIBezierPath *drawPath;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) BOOL leftToRight;

@property (nonatomic, weak) UIView *view;

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

+ (RGGradientObsever *)addObserverWithView:(UIView *)view
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
        [view rg_addObserver:ob forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:@"RGGradientColors"];
    }
    
    ob.leftToRight = view.rg_layoutLeftToRight;
    ob.drawColors = colors;
    ob.drawLocations = locations;
    ob.drawPath = path;
    ob.drawType = drawType;
    ob.drawRad = rad;
    ob.isDrawRad = isDrawRad;
    ob.bounds = view.bounds;
    ob.view = view;
    return ob;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context && [@"RGGradientColors" isEqualToString:(__bridge NSString * _Nonnull)(context)]) {
        UIView *view = object;
        if (view != self.view) {
            return;
        }
        if (CGSizeEqualToSize(self.bounds.size, view.bounds.size) && self.leftToRight == view.rg_layoutLeftToRight) {
            return;
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reDraw) object:nil];
        [self performSelector:@selector(reDraw) withObject:nil afterDelay:0];
    }
}

- (void)reDraw {
    UIView *view = self.view;
    if (CGSizeEqualToSize(self.bounds.size, view.bounds.size) && self.leftToRight == view.rg_layoutLeftToRight) {
        return;
    }
    self.bounds = self.view.bounds;
    self.leftToRight = view.rg_layoutLeftToRight;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reDraw) object:nil];
    if (self.isDrawRad) {
        [view rg_setBackgroundGradientColors:self.drawColors locations:self.drawLocations path:self.drawPath drawRad:self.drawRad];
    } else {
        [view rg_setBackgroundGradientColors:self.drawColors locations:self.drawLocations path:self.drawPath drawType:self.drawType];
    }
}

- (RGDrawType)currentDrawType {
    switch (_drawType) {
        case RGDrawTypeLeadingToTrailing: {
            return self.view.rg_layoutLeftToRight ? RGDrawTypeLeftToRight : RGDrawTypeRightToLeft;
        }
        default:
            return _drawType;
    }
}

@end

@implementation UIView (RGGradientBackgroundColor)

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
    RGGradientObsever *ob = [RGGradientObsever addObserverWithView:self colors:colors locations:locations path:path drawType:drawType drawRad:0 isDrawRad:NO];
    drawType = ob.currentDrawType;
    
    CALayer *layer = self.rg_gradientLayer;
    
    if (kDrawByContext) {
        layer.frame = self.layer.bounds;
        
        [NSObject rg_transformNumberLocations:locations toLocations:^(CGFloat * locations, void (^free)(void)) {
            NSNumber *gradientId = @(arc4random());
            self.rg_gradientId = gradientId;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *img = nil;
                UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, [UIScreen mainScreen].scale);
                {
                    CGContextRef gc = UIGraphicsGetCurrentContext();
                    [dPath rg_drawGradient:gc colors:colors locations:locations drawType:drawType];
                    img = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
                free();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.rg_gradientId != gradientId) {
                        return;
                    }
                    layer.contents = (__bridge id _Nullable)(img.CGImage);
                });
            });
        }];
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
    
    [NSObject rg_transformNumberLocations:locations toLocations:^(CGFloat * _Nonnull locations, void (^ _Nonnull free)(void)) {
        NSNumber *gradientId = @(arc4random());
        self.rg_gradientId = gradientId;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *img = nil;
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, [UIScreen mainScreen].scale);
            {
                CGContextRef gc = UIGraphicsGetCurrentContext();
                
                [dPath rg_drawLinearGradient:gc colors:colors locations:locations drawRad:rad];
                img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            free();
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.rg_gradientId != gradientId) {
                    return;
                }
                layer.contents = (__bridge id _Nullable)(img.CGImage);
            });
        });
    }];
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
