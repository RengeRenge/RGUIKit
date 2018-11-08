//
//  DrawViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/8.
//  Copyright © 2018 ld. All rights reserved.
//

#import "DrawViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface DrawViewController ()

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UIImageView *image4;
@property (nonatomic, strong) UIImageView *image5;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.image1 = [self createImageView];
    self.image2 = [self createImageView];
    self.image3 = [self createImageView];
    self.image4 = [self createImageView];
    self.image5 = [self createImageView];
}

- (UIImageView *)createImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    return imageView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.rg_safeAreaBounds;
    bounds.size.height /= 2;
    bounds.size.width /= 2;
    
    self.image1.frame = bounds;
    self.image2.frame = CGRectOffset(bounds, bounds.size.width, 0);
    self.image3.frame = CGRectOffset(bounds, 0, bounds.size.height);
    self.image4.frame = CGRectOffset(bounds, bounds.size.width, bounds.size.height);
    
    bounds.size.height = MIN(bounds.size.width, bounds.size.height);
    bounds.size.width = bounds.size.height;
    self.image5.frame = bounds;
    self.image5.center = self.image4.frame.origin;
    
    self.image1.image =
    [self test:RGUIBezierDrawTypeLTR bounds:self.image1.bounds];
    
    self.image2.image =
    [self test:RGUIBezierDrawTypeUTD bounds:self.image2.bounds];
    
    self.image3.image =
    [self test:RGUIBezierDrawTypeLUTRD45 bounds:self.image3.bounds];
    
    self.image4.image =
    [self test:RGUIBezierDrawTypeDiagonal bounds:self.image4.bounds];
    
    self.image5.image =
    [self test:RGUIBezierDrawTypeCircleFit bounds:self.image5.bounds];
}

- (UIImage *)test:(RGUIBezierDrawType)type bounds:(CGRect)bounds {
    bounds.origin = CGPointZero;
    
    //创建CGContextRef
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    
    CGFloat locations[] = {0.0, 0.6, 0.85, 0.9, 1.0};
    
    [bezierPath
     rg_drawLinearGradient:gc
     locations:locations
     colors:@[
              [UIColor redColor],
              [UIColor orangeColor],
              [[UIColor yellowColor] colorWithAlphaComponent:0.8f],
              [[UIColor whiteColor] colorWithAlphaComponent:0.f],
              [[UIColor whiteColor] colorWithAlphaComponent:0.f],
              ]
     drawType:type
     ];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
