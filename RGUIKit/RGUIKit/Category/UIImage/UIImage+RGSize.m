//
//  RGSize.m
//  RGUIKit
//
//  Created by renge on 2019/5/7.
//  Copyright © 2019 ld. All rights reserved.
//

#import "UIImage+RGSize.h"

@implementation UIImage (RGSize)


- (CGSize)rg_sizeThatFits:(CGSize)size stretch:(BOOL)stretch {
    CGSize imageSize = self.rg_logicSize;
    
    if (stretch) {
        CGFloat scale = size.width / imageSize.width;
        
        CGFloat width = size.width;
        CGFloat height = imageSize.height * scale;
        
        if (height > size.height) {
            scale = size.height / imageSize.height;
            imageSize.height = size.height;
            imageSize.width = imageSize.width * scale;
        } else {
            imageSize.height = height;
            imageSize.width = width;
        }
    } else {
        CGFloat scale = size.width / imageSize.width;
        if (scale < 1.f) {
            if (imageSize.height * scale > size.height) {
                scale = size.height / imageSize.height;
            }
            imageSize.height *= scale;
            imageSize.width *= scale;
        } else {
            scale = size.height / imageSize.height;
            if (scale < 1.f) {
                if (imageSize.width * scale > size.width) {
                    scale = size.width / imageSize.width;
                }
                imageSize.height *= scale;
                imageSize.width *= scale;
            }
        }
    }
    return imageSize;
}

- (CGSize)rg_sizeThatFill:(CGSize)size {
    CGSize imageSize = self.rg_logicSize;
    
    CGFloat scale = size.width / imageSize.width;
    
    CGFloat width = size.width;
    CGFloat height = imageSize.height * scale;
    
    if (height < size.height) {
        scale = size.height / imageSize.height;
        imageSize.height = size.height;
        imageSize.width = imageSize.width * scale;
    } else {
        imageSize.height = height;
        imageSize.width = width;
    }
    return imageSize;
}

- (CGSize)rg_logicSize {
    return [self rg_sizeWithScale:[UIScreen mainScreen].scale];
}

- (CGSize)rg_pixSize {
    CGSize imageSize = self.size;
    imageSize.width *= self.scale;
    imageSize.height *= self.scale;
    return imageSize;
}

- (CGSize)rg_sizeWithScale:(CGFloat)scale {
    CGSize imageSize = self.size;
    if (self.scale != scale && scale > 0) {
        scale = self.scale / scale;
        imageSize.height *= scale;
        imageSize.width *= scale;
    }
    return imageSize;
}

- (CGSize)rg_straightSize {
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            return CGSizeMake(self.size.height, self.size.width);
        default:
            return self.size;
            break;
    }
}

@end
