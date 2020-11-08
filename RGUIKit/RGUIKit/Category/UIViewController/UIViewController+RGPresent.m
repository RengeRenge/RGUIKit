//
//  UIViewController+Present.m
//  Batter
//
//  Created by Loc on 12-12-4.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import "UIViewController+RGPresent.h"

@implementation UIViewController (RGPresent)

- (void)rg_presentWithNavigationController:(void (^)(UINavigationController *navigationController))configBlock
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self];
    if (configBlock) {
        configBlock(navigationController);
    }
    [navigationController rg_presentWithCompletion:nil];
}

- (void)rg_presentWithCompletion:(void (^)(void))completion
{
    if (self.presentingViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    } else {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *presentedViewController = rootViewController;
        while (presentedViewController.presentedViewController) {
            if ([presentedViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
                [presentedViewController.presentedViewController rg_dismiss];
                break;
            } else {
                presentedViewController = presentedViewController.presentedViewController;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [presentedViewController presentViewController:self animated:YES completion:completion];
            } @catch (NSException *exception) {
                
            }
        });
    }
}

- (void)rg_presentWithoutDismissOtherWithCompletion:(void (^)(void))completion
{
    if (self.presentingViewController) {
        dispatch_async(dispatch_get_main_queue(), completion);
    } else {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *presentedViewController = rootViewController;
        while (presentedViewController.presentedViewController) {
            if ([presentedViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
                break;
            } else {
                presentedViewController = presentedViewController.presentedViewController;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                [presentedViewController presentViewController:self animated:YES completion:completion];
            } @catch (NSException *exception) {
                NSLog(@"");
            }
        });
    }
}

- (BOOL)rg_dismiss
{
//    UIViewController *parentViewController = self.parentViewController;
//    if (!parentViewController) {
//        parentViewController = self.presentingViewController;
//    }
    if (!self.presentingViewController) {
        return NO;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (BOOL)rg_dismissAnimated:(BOOL)animated completion:(void(^)(void))completion {
    if (!self.presentingViewController) {
        if (completion) {
            completion();
        }
        return NO;
    }
    [self.presentingViewController dismissViewControllerAnimated:animated completion:completion];
    return YES;
}

- (void)rg_dismissModalStackAnimated:(BOOL)animated completion:(void(^)(void))completion {
    
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    
    if (vc.presentedViewController) {
        [vc dismissViewControllerAnimated:animated completion:completion];
        return;
    }
    
    if (completion) {
        completion();
    }
}

+ (void)rg_dismissModalStackAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    UIViewController *vc = [self rg_topViewController];
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    
    if (vc.presentedViewController) {
        [vc dismissViewControllerAnimated:animated completion:completion];
        return;
    }
    
    if (completion) {
        completion();
    }
}

+ (UIViewController *)rg_topViewController {
    return [self rg_topViewControllerForWindow:[UIApplication sharedApplication].keyWindow];
}

+ (UIViewController *)rg_topViewControllerForWindow:(UIWindow *)window {
    
    UIViewController *resultVC = nil;
    resultVC = [self _rg_topViewController:window.rootViewController];
    while (resultVC.presentedViewController) {
        resultVC = [self _rg_topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_rg_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _rg_topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _rg_topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
