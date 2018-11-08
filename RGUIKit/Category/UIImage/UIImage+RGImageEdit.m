//
//  UIImage+JCPictureEdit.m
//  PictureEditor
//
//  Created by young on 2018/2/23.
//  Copyright © 2018年 young. All rights reserved.
//

#import "UIImage+RGImageEdit.h"
#import "UIImage+RGTint.h"

@implementation UIImage (RGImageEdit)

+ (UIImage *)rg_convertViewToImage:(UIView *)view {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

+ (UIImage *)rg_convertViewToImage:(UIView *)view rect:(CGRect)rect {
    UIImage *image = [self rg_convertViewToImage:view];
    if (CGRectEqualToRect(rect, view.bounds)) {
        return image;
    }
    image = [image rg_cropInRect:rect];
    return image;
}

- (UIImage *)rg_imageWithScale:(CGFloat)scale {
    if (self.scale == scale) {
        return self;
    }
    return [[UIImage alloc] initWithData:UIImagePNGRepresentation(self) scale:scale];
}

- (UIImage *)rg_imageWithScreenScale {
    return [self rg_imageWithScale:[UIScreen mainScreen].scale];
}

+ (UIImage *)rg_convertViewToImage:(UIView *)view size:(CGSize)size {
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = view.bounds.size;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

+ (UIImage *)rg_captureScrollView:(UIScrollView *)scrollView rect:(CGRect)rect {
    UIImage *image = nil;
    
    CGRect savedFrame = scrollView.frame;
    CGRect frame = scrollView.frame;
    
    if (CGRectIsEmpty(rect)) {
        frame.size = scrollView.contentSize;
    } else {
        frame.size = rect.size;
    }
    
    scrollView.frame = frame;
    image = [self rg_convertViewToImage:scrollView rect:rect];
    scrollView.frame = savedFrame;
    return image;
}

- (UIImage *)rg_cropInRect:(CGRect)rect {
    
    CGFloat scale = self.scale;
    
    CGRect pixRect = rect;
    pixRect.origin.x *= scale;
    pixRect.origin.y *= scale;
    pixRect.size.width *= scale;
    pixRect.size.height *= scale;
    
    return [self rg_cropInPixRect:pixRect];
}

- (UIImage *)rg_cropInPixRect:(CGRect)pixRect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, pixRect);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return subImage;
}

- (UIImage *)rg_coveredWithImage:(UIImage *)image pixRect:(CGRect)pixRect {
    if (!image) {
        return self;
    }
    
    CGFloat scale = self.scale;
    
    pixRect.origin.x /= scale;
    pixRect.origin.y /= scale;
    pixRect.size.width /= scale;
    pixRect.size.height /= scale;
    
    return [self rg_coveredWithImage:image rect:pixRect];
}

- (UIImage *)rg_coveredWithImage:(UIImage *)image rect:(CGRect)rect {
    if (!image) {
        return self;
    }
    
    CGFloat scale = self.scale;
    CGSize size = self.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    //图片在最下面的先画
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [image drawInRect:rect];
    
    UIImage *subImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return subImage;
}

- (UIImage *)rg_fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)rg_appendImage:(UIImage *)appendImage {
    return [UIImage rg_masterImage:self appendImage:appendImage];
}

+ (UIImage *)rg_masterImage:(UIImage *)masterImage appendImage:(UIImage *)appendImage {
    CGFloat scale = masterImage.scale;
    
    CGSize appendImageSize = [appendImage rg_sizeWithScale:scale];
    
    CGFloat height = appendImageSize.height * masterImage.size.width / appendImageSize.width;
    
    CGSize size;
    size.width = masterImage.size.width;
    size.height = masterImage.size.height + height;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    
    //Draw masterImage
    [masterImage drawInRect:CGRectMake(0, 0, size.width, masterImage.size.height)];
    
    //Draw slaveImage
    [appendImage drawInRect:CGRectMake(0, masterImage.size.height, size.width, height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
