//
//  UIView+RGGradientBackgroundColor.h
//  RGUIKit
//
//  Created by renge on 2021/6/4.
//

#import <UIKit/UIKit.h>
#import <RGUIKit/UIBezierPath+RGDraw.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RGGradientBackgroundColor)

- (CALayer *)rg_gradientLayer;

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

NS_ASSUME_NONNULL_END
