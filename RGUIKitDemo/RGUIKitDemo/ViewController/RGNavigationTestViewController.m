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

@end

@implementation RGNavigationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rg_randomColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
    
    if ([self.view.backgroundColor rg_isDarkColor]) {
        self.view.tintColor = [UIColor whiteColor];
    } else {
        self.view.tintColor = [UIColor blackColor];
    }
    
    self.buttons = @[
        [self buttonWithTitle:@"RGNavigationBackgroundStyleNone" tag:RGNavigationBackgroundStyleNone],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleNormal" tag:RGNavigationBackgroundStyleNormal],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleShadow" tag:RGNavigationBackgroundStyleShadow],
        [self buttonWithTitle:@"RGNavigationBackgroundStyleAllTranslucent" tag:RGNavigationBackgroundStyleAllTranslucent]
    ];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.rg_safeAreaBottomBounds;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds) - 60 - obj.frame.size.height * (idx + 1));
    }];
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
}

- (void)push {
    RGNavigationTestViewController *vc = [[RGNavigationTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)rg_navigationControllerShouldPop:(UINavigationController *)navigationController isInteractive:(BOOL)isInteractive {
    NSLog(@"will pop");
    [RGToastView showWithInfo:@"will pop" duration:3 percentY:0.8];
    return YES;
}

- (void)rg_navigationController:(UINavigationController *)navigationController interactivePopResult:(BOOL)finished {
    NSLog(@"will pop result:%d", finished);
    [RGToastView showWithInfo:[NSString stringWithFormat:@"pop result %d", finished] duration:3 percentY:0.8];
}

@end
