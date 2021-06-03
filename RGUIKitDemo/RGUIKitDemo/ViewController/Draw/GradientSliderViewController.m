//
//  GradientSliderViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2021/6/3.
//  Copyright © 2021 ld. All rights reserved.
//

#import "GradientSliderViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface GradientSliderViewController () <RGUINavigationControllerShouldPopDelegate>

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *sliderBar;

@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UILabel *displayLabel;

@property (nonatomic, strong) NSArray <UIColor *> *colors;
@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end

@implementation GradientSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.rg_systemBackgroundColor;
    self.colors = @[
        UIColor.rg_randomColor,
        UIColor.rg_randomColor,
        UIColor.rg_randomColor,
        UIColor.rg_randomColor,
    ];
    int a = [self random:0 b:30];
    int b = [self random:a + 10 b:60];
    int c = [self random:b + 10 b:80];
    int d = [self random:c + 10 b:100];
    
    self.locations = @[
        @(a/100.f), @(b/100.f), @(c/100.f), @(d/100.f),
    ];
    
    self.displayView = UIView.new;
    [self.view addSubview:self.displayView];
    
    self.displayLabel = UILabel.new;
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.displayLabel];
    
    self.sliderBar = [UIView new];
    [self.view addSubview:self.sliderBar];
    [self.sliderBar rg_setBackgroundGradientColors:self.colors locations:self.locations drawType:RGDrawTypeLeadingToTrailing];
    
    self.slider = [UISlider new];
    self.slider.minimumTrackTintColor = UIColor.clearColor;
    self.slider.maximumTrackTintColor = UIColor.clearColor;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 1;
    [self.view addSubview:self.slider];
    
    [self.slider addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged];
    [self onSlider:self.slider];
}

- (int)random:(int)a b:(int)b {
    return a + arc4random() % (b - a);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    
    self.slider.frame = CGRectMake(20, self.rg_layoutBottomY - 40, bounds.size.width - 40, 40);
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:0];
    trackRect = UIEdgeInsetsInsetRect(trackRect, UIEdgeInsetsMake(-5, thumbRect.size.width / 2.f, -5, thumbRect.size.width / 2.f));
    
    self.sliderBar.frame = [self.slider convertRect:trackRect toView:self.view];
    self.sliderBar.layer.cornerRadius = self.sliderBar.frame.size.height / 2;
    self.sliderBar.layer.masksToBounds = YES;
    
    bounds.size.height = CGRectGetMinY(self.slider.frame);
    self.displayView.frame = bounds;
    self.displayLabel.frame = bounds;
}

- (void)onSlider:(UISlider *)slider {
    UIColor *color = [UIColor rg_colorInLinearGradientColors:self.colors locations:self.locations colorLocation:@(slider.value)];
    self.displayView.backgroundColor = color;
    self.slider.thumbTintColor = color;
    
    CGFloat c[4];
    [color getRed:&c[0] green:&c[1] blue:&c[2] alpha:&c[3]];
    
    self.displayLabel.text = [NSString stringWithFormat:@"R:%.0f G:%.0f B:%.0f A:%.2f", c[0]*255, c[1]*255, c[2]*255, c[3]];
    self.displayLabel.textColor = color.rg_isDarkColor ? UIColor.whiteColor : UIColor.blackColor;
}

#pragma mark - RGUINavigationControllerShouldPopDelegate

- (BOOL)rg_navigationControllerShouldPop:(UINavigationController *)navigationController isInteractive:(BOOL)isInteractive {
    if (isInteractive) {
        return NO;
    }
    return YES;
}

@end
