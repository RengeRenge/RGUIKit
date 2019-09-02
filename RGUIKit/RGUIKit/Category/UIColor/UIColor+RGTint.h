//
//  UIColor+RGTint.h
//  Pods
//
//  Created by renge on 2019/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(RGTint)

- (BOOL)rg_isDarkColor;
+ (BOOL)rg_isDarkColorForR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;

@end

NS_ASSUME_NONNULL_END
