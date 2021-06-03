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
    
    RGDrawTypeRightToLeft,
    RGDrawTypeLeadingToTrailing // only valid for view background
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

@interface NSObject (RGCalGradientParam)

+ (void)rg_gradientParamWithBounds:(CGRect)bounds
                          drawType:(RGDrawType)drawType
                             param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit, BOOL circle, CGFloat radius))param;

+ (void)rg_gradientParamWithBounds:(CGRect)bounds
                               rad:(CGFloat)rad // pi
                             param:(void(NS_NOESCAPE^)(CGPoint sPonit, CGPoint ePonit))param;

@end

@interface UIImage (RGGradientImage)

+ (UIImage *)rg_gradientImageWithPath:(UIBezierPath *)path
                               colors:(NSArray <id> *)colors
                            locations:(NSArray <NSNumber *> *_Nullable)locations
                             drawType:(RGDrawType)drawType;

+ (UIImage *)rg_gradientImageWithPath:(UIBezierPath *)path
                               colors:(NSArray <id> *)colors
                            locations:(NSArray <NSNumber *> *_Nullable)locations
                              drawRad:(CGFloat)rad;

@end

@interface NSArray (RGGradientColors)

- (NSMutableArray *)rg_CGColors;

@end

@interface NSObject (RGGradientLocations)

+ (void)rg_transformNumberLocations:(NSArray <NSNumber *> *)loc toLocations:(void (NS_NOESCAPE^)(CGFloat * _Nonnull locations, void (^_Nonnull free)(void)))locations;

@end

NS_ASSUME_NONNULL_END
