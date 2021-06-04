//
//  PopTestViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import "PopTestViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface PopTestViewController () 

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PopTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSData *data = [NSData rg_littleEndianDataWithInt32:-2147483648];
//    NSLog(@"%@, %d", data, data.rg_littleEndianToInt32);
//
//    data = [NSData rg_littleEndianDataWithInt64:-4147483648];
//    NSLog(@"%@, %lld", data, data.rg_littleEndianToInt64);
//
//    data = [NSData rg_littleEndianDataWithFloat32:88.556677];
//    NSLog(@"%@, %f", data, data.rg_littleEndianToFloat32);
//
//    data = [NSData rg_littleEndianDataWithFloat64:-8847483648.123456789];
//    NSLog(@"%@, %f", data, data.rg_littleEndianToFloat64);
//
//    data = [NSData rg_littleEndianDataWithUInt16:65535];
//    NSLog(@"%@, %hu", data, data.rg_littleEndianToUInt16);
//
//    data = [NSData rg_littleEndianDataWithUInt32:4294967295];
//    NSLog(@"%@, %u", data, (unsigned int)data.rg_littleEndianToUInt32);
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
