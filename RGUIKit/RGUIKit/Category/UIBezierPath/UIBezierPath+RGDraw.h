//
//  UIBezierPath+RGDraw.h
//  RGUIKit
//
//  Created by renge on 2018/11/8.
//  Copyright © 2018 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RGDrawTypeTopToBottom,
    RGDrawTypeLeftToRight,
    RGDrawTypeDiagonalTopRightToBottomLeft,
    RGDrawTypeDiagonalTopLeftToBottomRight,
    RGDrawTypeCircleFill,
    RGDrawTypeCircleFit,
} RGDrawType;


/**
 locations count need equal to colors count
 colors UIColor or CGColor
 */
@interface UIBezierPath (RGDraw)

- (void)rg_drawGradient:(CGContextRef)context
                 colors:(NSArray <id> *)colors
              locations:(CGFloat[_Nullable])locations
               drawType:(RGDrawType)drawType;

- (void)rg_drawLinearGradient:(CGContextRef)context
                       colors:(NSArray <id> *)colors
                    locations:(CGFloat[_Nullable])locations
                      drawRad:(CGFloat)rad;

- (void)rg_drawLinearGradient:(CGContextRef)context
                       colors:(NSArray<id> *)colors
                    locations:(CGFloat[_Nullable])locations
                   startPoint:(CGPoint)startPoint
                     endPoint:(CGPoint)endPoint;

- (void)rg_drawRadialGradient:(CGContextRef)context
                       colors:(NSArray<id> *)colors
                    locations:(CGFloat [_Nullable])locations
                       center:(CGPoint)center
                       radius:(CGFloat)radius;

@end

@interface UIView (RGGradient)

- (void)rg_setBackgroundGradientColors:(NSArray <id> *)colors
                             locations:(NSArray <NSNumber *> *_Nullable)locations
                              drawType:(RGDrawType)drawType;

- (void)rg_setBackgroundGradientColors:(NSArray <id> *)colors
                             locations:(NSArray <NSNumber *> *_Nullable)locations
                               drawRad:(CGFloat)rad;

- (void)rg_setBackgroundGradientColors:(NSArray <id> *)colors
                             locations:(NSArray <NSNumber *> *_Nullable)locations
                                  path:(UIBezierPath *_Nullable)path
                              drawType:(RGDrawType)drawType;

- (void)rg_setBackgroundGradientColors:(NSArray <id> *)colors
                             locations:(NSArray <NSNumber *> *_Nullable)locations
                                  path:(UIBezierPath *_Nullable)path
                               drawRad:(CGFloat)rad;

- (void)rg_removeBackgroundGradientColors;

@end

@interface NSObject (RGCalGradientParam)

+ (void)rg_gradientParamWithBounds:(CGRect)bounds
                          drawType:(RGDrawType)drawType
                             param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit, BOOL circle, CGFloat radius))param;

+ (void)rg_gradientParamWithBounds:(CGRect)bounds
                               rad:(CGFloat)rad // pi
                             param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit))param;

@end

@interface NSArray (RGGradientColors)

- (NSMutableArray *)rg_CGColors;

@end

NS_ASSUME_NONNULL_END
