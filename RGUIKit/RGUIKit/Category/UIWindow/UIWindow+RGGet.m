//
//  UIWindow+RGGet.m
//  RGUIKit
//
//  Created by renge on 2020/12/10.
//

#import "UIWindow+RGGet.h"

@implementation UIScene(RGGet)

+ (UIWindowScene *_Nullable)rg_firstWindowScene {
    NSEnumerator *scenes = [UIApplication.sharedApplication.connectedScenes.allObjects objectEnumerator];
    for (UIScene *scene in scenes) {
        if (scene.activationState != UISceneActivationStateUnattached &&
            [scene isKindOfClass:UIWindowScene.class] &&
            [scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]
            ) {
            return (UIWindowScene *)scene;
        }
    }
    return nil;
}

+ (UIWindowScene *)rg_firstActiveWindowScene {
    NSEnumerator *scenes = [UIApplication.sharedApplication.connectedScenes.allObjects objectEnumerator];
    for (UIScene *scene in scenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive &&
            [scene isKindOfClass:UIWindowScene.class] &&
            [scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)]
            ) {
            return (UIWindowScene *)scene;
        }
    }
    return nil;
}

+ (UIWindowScene *)rg_sceneWithViewController:(UIViewController *)viewController {
    UIWindowScene *scene = viewController.view.window.windowScene;
    if (!scene) {
        scene = viewController.navigationController.view.window.windowScene;
    }
    if (!scene) {
        scene = viewController.tabBarController.view.window.windowScene;
    }
    if (!scene && viewController.presentingViewController) {
        scene = [self rg_sceneWithViewController:viewController];
    }
    return scene;
}

- (UIWindow *)rg_firstWindow {
    if (![self isKindOfClass:UIWindowScene.class]) {
        return nil;
    }
    return [UIWindow rg_firstWindowForwindows:((UIWindowScene *)self).windows];
}

- (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel {
    if (![self isKindOfClass:UIWindowScene.class]) {
        return nil;
    }
    return [UIWindow rg_frontWindow:maxSupportedWindowLevel windows:((UIWindowScene *)self).windows];
}

@end

@implementation UIWindow(RGGet)

+ (UIWindow *)rg_firstWindow {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        window = [[UIScene rg_firstWindowScene] rg_firstWindow];
    }
    if (!window) {
        window = [self rg_firstWindowForwindows:UIApplication.sharedApplication.windows];
    }
    return window;
}

+ (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        window = [self rg_frontWindow:maxSupportedWindowLevel windows:[UIScene rg_firstWindowScene].windows];
    }
    if (!window) {
        window = [self rg_frontWindow:maxSupportedWindowLevel windows:UIApplication.sharedApplication.windows];
    }
    return window;
}

+ (UIWindow *)rg_frontWindow:(UIWindowLevel)maxSupportedWindowLevel windows:(NSArray <UIWindow *> *)windows {
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= maxSupportedWindowLevel);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
#endif
    return nil;
}

+ (UIWindow *)rg_firstWindowForwindows:(NSArray <UIWindow *> *)windows {
#if !defined(SV_APP_EXTENSIONS)
    for (UIWindow *window in windows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowLevelSupported = window.windowLevel == UIWindowLevelNormal;
        if (windowOnMainScreen && windowLevelSupported) {
            return window;
        }
    }
#endif
    return nil;
}

@end

@implementation UIViewController(RGGet)

+ (UIViewController *)rg_topViewControllerByVc:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self rg_topViewControllerByVc:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self rg_topViewControllerByVc:[(UITabBarController *)vc selectedViewController]];
    } else if (vc) {
        UIViewController *temp = vc;
        while (temp.presentedViewController) {
            temp = temp.presentedViewController;
        }
        return temp;
    }
    return nil;
}

+ (UIViewController *)rg_topViewControllerByWindow:(UIWindow *)window {
    return [self rg_topViewControllerByVc:window.rootViewController];
}

+ (UIViewController *)rg_topViewControllerByScene:(UIScene *)scene {
    return [self rg_topViewControllerByWindow:scene.rg_firstWindow];
}

+ (UIViewController *)rg_topViewController {
    if (@available(iOS 13, *)) {
        UIScene *scene = [UIScene rg_firstWindowScene];
        if (scene) {
            return [self rg_topViewControllerByScene:scene];
        }
    }
    return [self rg_topViewControllerByWindow:[UIWindow rg_firstWindow]];
}

- (UIWindowScene *)rg_scene {
    return [UIScene rg_sceneWithViewController:self];
}

@end
