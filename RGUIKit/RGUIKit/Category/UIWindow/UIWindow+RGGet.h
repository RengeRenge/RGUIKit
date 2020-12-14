//
//  UIWindow+RGGet.h
//  RGUIKit
//
//  Created by renge on 2020/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScene(RGGet)

+ (UIWindowScene * _Nullable)rg_firstWindowScene;
+ (UIWindowScene * _Nullable)rg_firstActiveWindowScene;
+ (UIWindowScene *)rg_sceneWithViewController:(UIViewController *)viewController;

- (UIWindow *)rg_firstWindow;
- (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel;

@end

@interface UIWindow(RGGet)

/// search firstWindowScene if available iOS 13 else UIApplication.sharedApplication.windows
+ (UIWindow *)rg_firstWindow;
+ (UIWindow *)rg_firstWindowForwindows:(NSArray <UIWindow *> *)windows;

/// search firstWindowScene if available iOS 13 else UIApplication.sharedApplication.windows
+ (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel;
+ (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel windows:(NSArray <UIWindow *> *)windows;

@end


@interface UIViewController(RGGet)

+ (UIViewController *)rg_topViewControllerByVc:(UIViewController *)vc;
+ (UIViewController *)rg_topViewControllerByWindow:(UIWindow *)window;
+ (UIViewController *)rg_topViewControllerByScene:(UIScene *)scene API_AVAILABLE(ios(13.0));

/// search firstWindowScene if available iOS 13 else firstWindow
+ (UIViewController *)rg_topViewController;

- (UIWindowScene *)rg_scene API_AVAILABLE(ios(13.0));

@end



NS_ASSUME_NONNULL_END
