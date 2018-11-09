//
//  RGNavigationTestViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//  Copyright © 2018 ld. All rights reserved.
//

#import "RGNavigationTestViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface RGNavigationTestViewController ()

@end

@implementation RGNavigationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor rg_randomColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
}

- (void)push {
    RGNavigationTestViewController *vc = [[RGNavigationTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
