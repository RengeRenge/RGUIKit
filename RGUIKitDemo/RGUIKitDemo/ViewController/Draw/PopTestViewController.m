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
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
