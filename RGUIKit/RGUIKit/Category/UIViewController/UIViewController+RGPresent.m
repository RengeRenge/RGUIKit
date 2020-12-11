//
//  UIViewController+Present.m
//  Batter
//
//  Created by Loc on 12-12-4.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import "UIViewController+RGPresent.h"
#import "UIWindow+RGGet.h"

@implementation UIViewController (RGPresent)

- (void)rg_topPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self rg_presentViewController:viewControllerToPresent animated:flag dismissOther:nil completion:completion];
}

- (void)rg_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag dismissOther:(BOOL (^)(UIViewController *))dismissOther completion:(void (^)(void))completion {
    if (viewControllerToPresent.presentingViewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    } else {
        UIViewController *top = self;
        while (top.presentedViewController) {
            if (dismissOther && dismissOther(top.presentedViewController)) {
                [top.presentedViewController rg_dismissAnimated:YES completion:^{
                    [top presentViewController:viewControllerToPresent animated:YES completion:completion];
                }];
                return;
            } else {
                top = top.presentedViewController;
            }
        }
        [top presentViewController:viewControllerToPresent animated:YES completion:completion];
    }
}

- (BOOL)rg_dismiss {
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

@end
