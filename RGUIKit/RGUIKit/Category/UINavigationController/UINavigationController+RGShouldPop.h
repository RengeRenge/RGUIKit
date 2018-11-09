//
//  UINavigationController+ShouldPop.h
//  JusTalk
//
//  Created by juphoon on 2018/3/21.
//  Copyright © 2018年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIViewController implement this delegate
 */
@protocol RGUINavigationControllerShouldPopDelegate <NSObject>

- (BOOL)rg_navigationControllerShouldPop:(UINavigationController *)navigationController isInteractive:(BOOL)isInteractive;

- (void)rg_navigationController:(UINavigationController *)navigationController interactivePopResult:(BOOL)finished;

@end

@interface UINavigationController (RGShouldPop)

- (void)rg_updateSemanticContentAttribute;

@end
