//
//  DrawLineCustomViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2019/11/23.
//  Copyright © 2019 ld. All rights reserved.
//

#import "DrawLineCustomViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface DrawLineCustomViewController () {
    NSMutableArray <NSNumber *> *locations;
}

@property (nonatomic, strong) UISlider *silder;

@end

@implementation DrawLineCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    locations = [NSMutableArray arrayWithArray:@[@0, @0.5, @1]];
    
    _silder = [[UISlider alloc] init];
    _silder.minimumValue = 0;
    _silder.maximumValue = 360;
    [_silder addTarget:self action:@selector(radChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_silder];
    self.navigationItem.title = @(_silder.value).stringValue;
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:ges];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSArray *colors = @[
        UIColor.redColor,
        UIColor.whiteColor,
        UIColor.yellowColor
    ];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.rg_safeAreaBounds];
    [self.view rg_setBackgroundGradientColors:colors locations:locations path:path drawRad:_silder.value/180*M_PI];
    
    CGRect frame = self.rg_safeAreaBottomBounds;
    _silder.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-frame.size.height, 80, frame.size.height, 80));
}

- (void)radChanged:(UISlider *)slider {
    [self.view setNeedsLayout];
    self.navigationItem.title = @(slider.value).stringValue;
}

- (void)swipe:(UIPanGestureRecognizer *)pan {
    CGPoint transP = [pan translationInView:self.view];
    CGFloat value = MIN(1, MAX(0, locations[1].floatValue - transP.x / self.view.bounds.size.width / 2.f));
    locations[1] = @(value);
    [pan setTranslation:CGPointZero inView:self.view];
    
    [self.view setNeedsLayout];
}

@end
