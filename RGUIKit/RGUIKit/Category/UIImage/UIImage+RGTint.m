//
//  UIImage+Tint.m
//  Batter
//
//  Created by Cathy on 12-8-15.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import "UIImage+RGTint.h"
#import "UIImage+RGSize.h"

@implementation UIImage (RGTint)

+ (UIImage *)rg_coloredImage:(UIColor *)color size:(CGSize)imageSize
{
    if (imageSize.width == 0 || imageSize.height == 0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)rg_circleImageWithColor:(UIColor *)color size:(CGSize)imageSize radius:(CGFloat)radius {
    
    if (imageSize.width == 0 || imageSize.height == 0 || radius == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, radius, 0);
    CGContextAddLineToPoint(context, width - radius,0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 *M_PI,0.0,0);
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius,0.0,0.5 *M_PI,0);
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius,0.5 *M_PI,M_PI,0);
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius,M_PI,1.5 *M_PI,0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextDrawPath(context,kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)rg_templateImageWithSize:(CGSize)imageSize {
    UIImage *image = [self rg_coloredImage:[UIColor whiteColor] size:imageSize];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

+ (UIImage *)rg_templateImageNamed:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)rg_templateCircleImageWithSize:(CGSize)imageSize radius:(CGFloat)radius {
    UIImage *image = [self rg_circleImageWithColor:[UIColor whiteColor] size:imageSize radius:radius];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}

- (UIImage *)rg_imageWithColor:(UIColor *)tintColor
{
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGRect drawRect = CGRectMake(0, 0, size.width, size.height);
    [self drawInRect:drawRect];
    [tintColor set];
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)rg_applyingAlpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)rg_hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

//根据图片获取图片的主色调
- (UIColor *)rg_mainColor {
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = [self rg_sizeThatFits:CGSizeMake(50/[UIScreen mainScreen].scale, 50/[UIScreen mainScreen].scale) stretch:NO];
    thumbSize.width *= [UIScreen mainScreen].scale;
    thumbSize.height *= [UIScreen mainScreen].scale;
    
    CGImageRef cgImage = self.CGImage;
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(cgImage);
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 0,
                                                 colorSpace,
                                                 CGImageGetBitmapInfo(cgImage));
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, cgImage);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) {CGContextRelease(context); return nil;}
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

@end
