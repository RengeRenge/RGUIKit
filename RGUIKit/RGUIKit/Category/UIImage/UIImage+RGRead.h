//
//  UIImage+Read.h
//  JusTalk
//
//  Created by Jori on 2017/3/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RGRead)

+ (UIImage *)rg_imageWithName:(NSString *)name;    // default extensionName png
+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension;

+ (UIImage *)rg_imageWithName:(NSString *)name inBundle:(NSBundle *__nullable)bundle;
+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension inBundle:(NSBundle *__nullable)bundle;

+ (UIImage *)rg_imageWithName:(NSString *)name inBundleClass:(__nullable Class)bundleClass;
+ (UIImage *)rg_imageWithFullName:(NSString *)fullName extension:(NSString *)extension inBundleClass:(__nullable Class)bundleClass;

@end

NS_ASSUME_NONNULL_END
