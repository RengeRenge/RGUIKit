//
//  RGNavigationTestViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//  Copyright © 2018 ld. All rights reserved.
//

#import "RGNavigationTestViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface RGNavigationTestViewController () <RGUINavigationControllerShouldPopDelegate>

@property (nonatomic, strong) NSArray <UIButton *> *buttons;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, assign) RGNavigationBackgroundStyle style;

@end

@implementation RGNavigationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rg_randomColor];
    self.rg_navigationController.scrollEdgeKeepPaceWithStandard = YES;
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:ges];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
    
    if ([self.view.backgroundColor rg_isDarkColor]) {
        self.view.tintColor = [UIColor whiteColor];
        self.rg_navigationController.tintColor = [UIColor whiteColor];
    } else {
        self.view.tintColor = [UIColor blackColor];
        self.rg_navigationController.tintColor = [UIColor blackColor];
    }
    self.slider = UISlider.new;
    self.slider.value = self.rg_navigationController.navigationBar.rg_backgroundAlpha;
    [self.slider addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.style = self.rg_navigationController.barBackgroundStyle;
    [self configTitile];
    
    self.buttons = @[
        [self buttonWithTitle:@"RGNavigationBackgroundStyleNone" tag:RGNavigationBackgroundStyleNone],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleNormal" tag:RGNavigationBackgroundStyleNormal],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleShadow" tag:RGNavigationBackgroundStyleShadow],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleAllTranslucent" tag:RGNavigationBackgroundStyleAllTranslucent]
    ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.rg_navigationController.navigationBar.rg_backgroundAlpha = self.slider.value;
    self.rg_navigationController.barBackgroundStyle = self.style;
    
    [self configTitileTintColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.rg_safeAreaBottomBounds;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds) - 60 - obj.frame.size.height * (idx + 1));
    }];
    self.slider.frame = CGRectMake(40, self.view.center.y - 20, bounds.size.width - 80, 40);
}

- (void)tap:(UITapGestureRecognizer *)ges {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.isHidden animated:YES];
}

- (void)onSlider:(UISlider *)slider {
    self.rg_navigationController.navigationBar.rg_backgroundAlpha = slider.value;
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    [button sizeToFit];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)changeType:(UIButton *)sender {
    self.rg_navigationController.barBackgroundStyle = sender.tag;
    self.style = self.rg_navigationController.barBackgroundStyle;
    [self configTitileTintColor];
    [self configTitile];
}

- (void)push {
    RGNavigationTestViewController *vc = [[RGNavigationTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.rg_navigationController.barBackgroundStyle == RGNavigationBackgroundStyleShadow) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)configTitile {
    NSString *title = nil;
    switch (self.style) {
        case RGNavigationBackgroundStyleAllTranslucent:
            title = @"AllTranslucent";
            break;
        case RGNavigationBackgroundStyleNormal:
            title = @"Normal";
            break;
        case RGNavigationBackgroundStyleShadow:
            title = @"Shadow";
            break;
        case RGNavigationBackgroundStyleNone:
            title = @"None";
            break;
        default:
            break;
    }
    self.title = title;
}

- (void)configTitileTintColor {
    if (self.rg_navigationController.barBackgroundStyle == RGNavigationBackgroundStyleShadow) {
        self.rg_navigationController.tintColor = UIColor.whiteColor;
    } else {
        self.rg_navigationController.tintColor = UIColor.rg_labelColor;
    }
}

- (BOOL)rg_navigationControllerShouldPop:(UINavigationController *)navigationController isInteractive:(BOOL)isInteractive {
    NSLog(@"will pop");
    [RGToastView showWithInfo:@"will pop" duration:3 percentY:0.8 viewController:self];
    return YES;
}

- (void)rg_navigationController:(UINavigationController *)navigationController interactivePopResult:(BOOL)finished {
    NSLog(@"will pop result:%d", finished);
    [RGToastView showWithInfo:[NSString stringWithFormat:@"pop result %d", finished] duration:3 percentY:0.8 viewController:self];
}

@end
