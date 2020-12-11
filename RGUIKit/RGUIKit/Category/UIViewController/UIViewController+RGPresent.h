//
//  UIViewController+Present.h
//  Batter
//
//  Created by Loc on 12-12-4.
//  Copyright (c) 2012年 Juphoon.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RGPresent)

- (void)rg_topPresentViewController:(UIViewController *)viewControllerToPresent
                           animated:(BOOL)flag
                         completion:(void (^)(void))completion;

- (void)rg_presentViewController:(UIViewController *)viewControllerToPresent
                        animated:(BOOL)flag
                    dismissOther:(BOOL(^)(UIViewController *viewController))dismissOther
                      completion:(void (^)(void))completion;

- (BOOL)rg_dismiss;
- (BOOL)rg_dismissAnimated:(BOOL)animated completion:(void(^)(void))completion;

- (void)rg_dismissModalStackAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
