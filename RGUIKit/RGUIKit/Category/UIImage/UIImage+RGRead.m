//
//  UIImage+Read.m
//  JusTalk
//
//  Created by Jori on 2017/3/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UIImage+RGRead.h"
#import "UIImage+RGName.h"
#import "NSBundle+RGGET.h"

@implementation UIImage (RGRead)

+ (UIImage *)rg_imageWithName:(NSString *)name {
    return [self rg_imageWithName:name inBundle:nil];;
}

+ (UIImage *)rg_imageWithName:(NSString *)name inBundle:(NSBundle * _Nullable)bundle {
    if (!name || name.length == 0) {
        return nil;
    }
    
    NSString *extension = nil;
    NSString *imageName = [self rg_imageNameWithName:name extension:&extension];
    return [self rg_imageWithFullName:imageName extension:extension inBundle:bundle];
}

+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension {
    return [self rg_imageWithFullName:fullName extension:extension inBundle:nil];
}

+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension inBundle:(NSBundle * _Nullable)bundle {
    if (!fullName || fullName.length == 0) {
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:fullName inBundle:bundle compatibleWithTraitCollection:nil];
    if (image) {
        return image;
    }
    
    image = [UIImage imageNamed:fullName inBundle:[NSBundle rg_bundleWithFramework:bundle] compatibleWithTraitCollection:nil];
    if (image) {
        return image;
    }
    
    NSString *filePath = [self rg_filePathWithName:fullName scale:0 extension:extension inBundle:bundle];
    
    NSInteger scale = [UIScreen mainScreen].scale;
    if (!filePath) {
        filePath = [self rg_filePathWithName:fullName scale:scale extension:extension inBundle:bundle];
    }
    
    if (!filePath) {
        filePath = [self rg_filePathWithName:fullName scale:2 extension:extension inBundle:bundle];
    }
    
    NSInteger fixScale = 3;
    while (!filePath && fixScale > 0 && fixScale != 2) {
        if (fixScale != scale) {
            filePath = [self rg_filePathWithName:fullName scale:fixScale extension:extension inBundle:bundle];
        }
        fixScale--;
    }
    
    if (!filePath) {
        return nil;
    }
    
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)rg_imageWithName:(NSString *)name inBundleClass:(Class)bundleClass {
    return [self rg_imageWithName:name inBundle:[NSBundle rg_frameworkForClass:bundleClass]];
}

+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension inBundleClass:(Class)bundleClass {
    return [self rg_imageWithFullName:fullName extension:extension inBundle:[NSBundle rg_frameworkForClass:bundleClass]];
}

+ (NSString *)rg_filePathWithName:(NSString *)name scale:(NSInteger)scale extension:(NSString *)extension inBundle:(NSBundle * _Nullable)bundle {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    if (scale > 0) {
        name = [name stringByAppendingFormat:@"@%ldx", (long)scale];
    }
    NSString *filePath = [bundle pathForResource:name ofType:extension];
    if (!filePath) {
        if ([bundle.bundlePath hasSuffix:@".framework"]) {
            NSString *name = bundle.bundlePath.lastPathComponent.stringByDeletingPathExtension;
            NSString *bundlePath = [bundle pathForResource:name ofType:@"bundle"];
            bundle = [NSBundle bundleWithPath:bundlePath];
        }
        filePath = [bundle pathForResource:name ofType:extension];
    }
    if (!filePath) {
        filePath = [bundle pathForResource:name ofType:nil];
    }
    return filePath;
}

@end
