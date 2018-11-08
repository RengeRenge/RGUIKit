//
//  UIImage+RGIconCell.h
//  RGUIKit
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RGIconResizeMode) {
    RGIconResizeModeNone,             // 不改变图片大小
    RGIconResizeModeCenter,           // 裁剪图片中心区域
    RGIconResizeModeScaleAspectFill,  // 最大尺寸裁剪图片，再缩放至全部显示 (默认)
    RGIconResizeModeScaleAspectFit,   // 缩放图片到能全部显示为止，可能会留白
};

@interface UIImage (RGIconCellResize)

+ (UIImage *)rg_resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height iconResizeMode:(RGIconResizeMode)iconResizeMode;

- (UIImage *)rg_resizeImageWithSize:(CGSize)size iconResizeMode:(RGIconResizeMode)iconResizeMode;

- (UIImage *)rg_resizeImageWithWidth:(CGFloat)width height:(CGFloat)height iconResizeMode:(RGIconResizeMode)iconResizeMode;

@end

NS_ASSUME_NONNULL_END
