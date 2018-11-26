//
//  UIImage+RGIconCell.m
//  RGUIKit
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import "UIImage+RGIconCell.h"
#import "UIImage+RGTint.h"

@implementation UIImage (RGIconCellResize)

- (UIImage *)rg_resizeImageWithSize:(CGSize)size iconResizeMode:(RGIconResizeMode)iconResizeMode {
    return [UIImage rg_resizeImage:self width:size.width height:size.height iconResizeMode:iconResizeMode];
}

- (UIImage *)rg_resizeImageWithWidth:(CGFloat)width height:(CGFloat)height iconResizeMode:(RGIconResizeMode)iconResizeMode {
    return [UIImage rg_resizeImage:self width:width height:height iconResizeMode:iconResizeMode];
}

+ (UIImage *)rg_resizeImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height iconResizeMode:(RGIconResizeMode)iconResizeMode {
    
    if (RGIconResizeModeScaleAspectFit == iconResizeMode) {
        
        CGFloat scaleWidth = width;
        CGFloat scale = scaleWidth / image.size.width;
        CGFloat scaleHeight = image.size.height * scale;
        
        if (scaleHeight > height) {
            scaleHeight = height;
            scale = height / image.size.height;
            scaleWidth = scale * image.size.width;
        }
        if (scale < 1) {
            return [self scaleImage:image size:CGSizeMake(scaleWidth, scaleHeight)];
        } else {
            return image;
        }
        
    } else if (RGIconResizeModeCenter == iconResizeMode) {
        
        BOOL needCut = (image.size.width > width || image.size.height > height);
        
        if (needCut) {
            
            if (image.size.width < width) {
                width = image.size.width;
            }
            
            if (image.size.height < height) {
                height = image.size.height;
            }
            
            CGFloat x = (image.size.width - width) / 2;
            CGFloat y = (image.size.height - height) / 2;
            
            CGFloat imageScale = image.scale;
            
            CGRect subRect = CGRectMake(imageScale * x,
                                        imageScale * y,
                                        imageScale * width,
                                        imageScale * height
                                        );
            return [self subImage:image inRect:subRect];
        }
        
    } else if (RGIconResizeModeScaleAspectFill == iconResizeMode) {
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        
        BOOL needResize = !(width == imageWidth && height == imageHeight);
        if (needResize) {
            
            CGFloat ratio = width / height;
            BOOL needCut = (ratio != (imageWidth / imageHeight));
            
            if (needCut) {
                
                CGFloat cutWidth = image.size.width;
                CGFloat cutHeight = cutWidth / ratio;
                
                if (cutHeight > image.size.height) {
                    cutHeight = image.size.height;
                    cutWidth = cutHeight * ratio;
                }
                CGFloat x = (image.size.width - cutWidth) / 2;
                CGFloat y = (image.size.height - cutHeight) / 2;
                
                CGFloat imageScale = image.scale;
                
                CGRect subRect = CGRectMake(imageScale * x,
                                            imageScale * y,
                                            imageScale * cutWidth,
                                            imageScale * cutHeight
                                            );
                image = [self subImage:image inRect:subRect];
            }
            
            //set scaleSize
            CGFloat scaleSize = width / image.size.width;
            
            if (image.size.height * scaleSize < height) {
                
                scaleSize = height / image.size.height;
            }
            
            if (scaleSize < 1) {
                //scale
                return [self scaleImage:image size:CGSizeMake(width, height)];
            }
        }
    }
    return image;
}

/** cut a image in rect */
+ (UIImage *)subImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef scale:image.scale orientation:UIImageOrientationUp];
    
    CGImageRelease(subImageRef);
    
    return smallImage;
    
    //    // compress image
    //    return [UIImage imageWithData:UIImageJPEGRepresentation(smallImage, 0.5)];
}

/** scale a image */

+ (UIImage *)scaleImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/** scale a image */
+ (UIImage *)scaleImage:(UIImage *)image scale:(CGFloat)scale
{
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
