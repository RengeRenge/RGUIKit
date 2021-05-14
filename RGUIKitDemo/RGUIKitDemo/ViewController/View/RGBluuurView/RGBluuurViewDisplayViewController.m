//
//  RGBluuurViewDisplayViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2021/5/14.
//  Copyright © 2021 ld. All rights reserved.
//

#import "RGBluuurViewDisplayViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface RGBluuurViewDisplayViewController () <RGUINavigationControllerShouldPopDelegate>

@property (nonatomic, strong) RGBluuurView *blurView;
@property (nonatomic, strong) UILabel *blurLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation RGBluuurViewDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view rg_setBackgroundGradientColors:@[UIColor.rg_randomColor, UIColor.rg_randomColor, UIColor.rg_randomColor, UIColor.rg_randomColor] locations:nil drawType:RGDrawTypeTopToBottom];
    
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage rg_imageWithFullName:@"nyapass" extension:@"jpg"]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    self.slider = [[UISlider alloc] init];
    self.slider.minimumValue = 0;
    self.slider.maximumValue = 100;
    [self.view addSubview:self.slider];
    
    _blurView = [[RGBluuurView alloc] initWithEffect:[RGBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _blurView.layer.cornerRadius = 60;
    _blurView.layer.borderColor = UIColor.rg_systemBackgroundColor.CGColor;
    _blurView.layer.borderWidth = 1;
    _blurView.layer.masksToBounds = YES;
    _blurView.frame = CGRectMake(0, 80, 120, 120);
    
    _blurLabel = [[UILabel alloc] init];
    _blurLabel.text = @"(੭ ᐕ)੭*⁾⁾";
    _blurLabel.font = [UIFont systemFontOfSize:20];
    [_blurLabel sizeToFit];
    
    [_blurView.vibrancyEffectView.contentView addSubview:_blurLabel];
    _blurLabel.center = _blurView.vibrancyEffectView.contentView.rg_centerInSuperView;
    _blurLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_blurView addGestureRecognizer:pan];
    
    [self.view addSubview:_blurView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"animate" style:UIBarButtonItemStylePlain target:self action:@selector(_doAnimation)];
    
    self.slider.value = self.blurView.blurRadius;
    [self.slider addTarget:self action:@selector(_onSlide:) forControlEvents:UIControlEventValueChanged];
    
    __block CGPoint p = self.view.center;
    p.y -= 120;
    self.blurView.center = p;
    [UIView animateWithDuration:0.5 animations:^{
        p = self.view.center;
        p.y -= 120;
        self.blurView.center = CGPointMake(p.x - 40, p.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            p = self.view.center;
            p.y -= 120;
            self.blurView.center = CGPointMake(p.x + 40, p.y);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                p = self.view.center;
                p.y -= 120;
                self.blurView.center = p;
            }];
        }];
    }];
    
    self.navigationItem.title = [NSString stringWithFormat:@"blurRadius:%.3f", self.slider.value];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.imageView.frame = self.view.bounds;
    CGRect frame = self.rg_safeAreaBottomBounds;
    if (!frame.size.height) {
        frame.size.height = 40;
        frame.origin.y -= 40;
    }
    self.slider.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-frame.size.height, 20, frame.size.height, 20));
}

- (void)_doAnimation {
    UIAlertController.rg_newAlert(@"RGBluuurView animate", @"config params", UIAlertControllerStyleAlert)
    .rg_addActionS(@"UIBlurEffectStyleLight", UIAlertActionStyleDefault, ^(UIAlertAction * _Nonnull action, UIAlertController * _Nonnull alert) {
        [self.blurView beginChangeToStyle:UIBlurEffectStyleLight];
        [UIView animateWithDuration:0.6 animations:^{
            self.blurView.blurRadius = alert.textFields.firstObject.text.intValue;
            [self.blurView commitChange];
            self.slider.value = self.blurView.blurRadius;
            self.navigationItem.title = [NSString stringWithFormat:@"blurRadius:%.3f", self.slider.value];
        }];
    })
    .rg_addActionS(@"UIBlurEffectStyleDark", UIAlertActionStyleDefault, ^(UIAlertAction * _Nonnull action, UIAlertController * _Nonnull alert) {
        [self.blurView beginChangeToStyle:UIBlurEffectStyleDark];
        [UIView animateWithDuration:0.6 animations:^{
            self.blurView.blurRadius = alert.textFields.firstObject.text.intValue;
            [self.blurView commitChange];
            self.slider.value = self.blurView.blurRadius;
            self.navigationItem.title = [NSString stringWithFormat:@"blurRadius:%.3f", self.slider.value];
        }];
    })
    .rg_addTextFieldS(^(UITextField * _Nonnull textField, UIAlertController * _Nonnull alert) {
        textField.placeholder = @"blurRadius";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    })
    .rg_presentedBy(self);
}

- (void)_onSlide:(UISlider *)slider {
    self.blurView.blurRadius = slider.value;
    self.navigationItem.title = [NSString stringWithFormat:@"blurRadius:%.3f", self.slider.value];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    [pan rg_eventValueChanged];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            pan.view.frame = CGRectMake(0, 0,
                                        pan.rg_gestureCurrentScale * pan.rg_gestureOriginSize.width,
                                        pan.rg_gestureCurrentScale * pan.rg_gestureOriginSize.height);
            pan.view.center = pan.rg_gestureCurrentCenter;
            break;
        }
        default:
            break;
    }
}


- (BOOL)rg_navigationControllerShouldPop:(UINavigationController *)navigationController isInteractive:(BOOL)isInteractive {
    return !isInteractive;
}

- (void)rg_navigationController:(UINavigationController *)navigationController interactivePopResult:(BOOL)finished {
    
}

@end
