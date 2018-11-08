//
//  UIViewController+Present.h
//  Batter
//
//  Created by Loc on 12-12-4.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RGPresent)

- (void)rg_presentWithNavigationController:(void (^)(UINavigationController *navigationController))configBlock;
- (void)rg_presentWithCompletion:(void (^)(void))completion;
- (void)rg_presentWithoutDismissOtherWithCompletion:(void (^)(void))completion;
+ (void)rg_dismissModalStackAnimated:(BOOL)animated completion:(void(^)(void))completion;
+ (UIViewController *)rg_topViewController;
+ (UIViewController *)rg_topViewControllerForWindow:(UIWindow *)window;
- (void)rg_dismiss;
- (void)rg_dismissAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
