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
    RGUIBezierDrawTypeUTD,
    RGUIBezierDrawTypeLTR,
    /// TopLeft to BottomRight 45 angle
    RGUIBezierDrawTypeLUTRD45,
    /// TopLeft to BottomRight
    RGUIBezierDrawTypeDiagonal,
    RGUIBezierDrawTypeCircleFill,
    RGUIBezierDrawTypeCircleFit,
} RGUIBezierDrawType;


/**
 locations.count need equal to colors.count
 colors UIColor or CGColor
 */
@interface UIBezierPath (RGDraw)

- (void)rg_drawLinearGradient:(CGContextRef)context
                    locations:(CGFloat[_Nullable])locations
                       colors:(NSArray <id> *)colors
                     drawType:(RGUIBezierDrawType)drawType;

- (void)rg_drawLinearGradient:(CGContextRef)context
                    locations:(CGFloat[_Nullable])locations
                       colors:(NSArray<id> *)colors
                   startPoint:(CGPoint)startPoint
                     endPoint:(CGPoint)endPoint;

- (void)rg_drawRadialGradient:(CGContextRef)context
                    locations:(CGFloat [_Nullable])locations
                       colors:(NSArray<id> *)colors
                       center:(CGPoint)center
                       radius:(CGFloat)radius;

@end

@interface NSArray (RGGradientColors)

- (NSMutableArray *)rg_CGColors;

@end

NS_ASSUME_NONNULL_END
