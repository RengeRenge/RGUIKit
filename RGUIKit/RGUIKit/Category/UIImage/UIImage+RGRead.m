//
//  UIImage+Read.m
//  JusTalk
//
//  Created by Jori on 2017/3/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIImage+RGRead.h"
#import "UIImage+RGName.h"

@implementation UIImage (RGRead)

+ (UIImage *)rg_imageWithName:(NSString *)name {
    if (!name || name.length == 0) {
        return nil;
    }
    
    NSString *extension = nil;
    NSString *imageName = [self rg_imageNameWithName:name extension:&extension];
    return [self rg_imageWithFullName:imageName extension:extension];
}

+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension {
    if (!fullName || fullName.length == 0) {
        return nil;
    }
    
    NSString *filePath = [self rg_filePathWithName:fullName scale:0 extension:extension];
    
    NSInteger scale = [UIScreen mainScreen].scale;
    if (!filePath) {
        filePath = [self rg_filePathWithName:fullName scale:scale extension:extension];
    }
    
    if (!filePath) {
        filePath = [self rg_filePathWithName:fullName scale:2 extension:extension];
    }
    
    NSInteger fixScale = 3;
    while (!filePath && fixScale > 0 && fixScale != 2) {
        if (fixScale != scale) {
            filePath = [self rg_filePathWithName:fullName scale:fixScale extension:extension];
        }
        fixScale--;
    }
    
    if (!filePath) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (NSString *)rg_filePathWithName:(NSString *)name scale:(NSInteger)scale extension:(NSString *)extension {
    if (scale > 0) {
        name = [name stringByAppendingFormat:@"@%ldx", (long)scale];
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    return filePath;
}

@end
