//
//  UIImage+name.m
//  JusTalk
//
//  Created by jiang  hao on 2017/5/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIImage+RGName.h"

@implementation UIImage (RGName)

+ (NSString *)rg_imageNameWithName:(NSString *)name extension:(NSString **)extension {
    NSString *imageName = nil;
    NSString *nameExtension = [name pathExtension];
    if (!nameExtension || nameExtension.length == 0) {
        imageName = name;
        nameExtension = @"png";
    } else {
        imageName = [name stringByDeletingPathExtension];
    }
    *extension = nameExtension;
    return imageName;
}

@end
