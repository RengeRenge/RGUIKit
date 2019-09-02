//
//  UINavigationController+ShouldPop.m
//  JusTalk
//
//  Created by juphoon on 2018/3/21.
//  Copyright © 2018年 juphoon. All rights reserved.
//

#import "UINavigationController+RGShouldPop.h"
#import "NSObject+RGRunTime.h"
#import <objc/runtime.h>

static char *rg_kOriginalDelegate = "rg_kOriginalDelegate";
static char *rg_kInteractiveViewController = "rg_kInteractiveViewController";

@interface UINavigationController () <UIGestureRecognizerDelegate>

@end

@implementation UINavigationController (RGShouldPop)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(navigationBar:shouldPopItem:);
        SEL swizzledSel = @selector(rg_navigationBar:shouldPopItem:);
        
        [self rg_swizzleOriginalSel:originalSel swizzledSel:swizzledSel];
        
        [self rg_swizzleOriginalSel:@selector(initWithNibName:bundle:) swizzledSel:@selector(rg_initWithNibName:bundle:)];
        
        [self rg_swizzleOriginalSel:@selector(initWithRootViewController:) swizzledSel:@selector(rg_initWithRootViewController:)];
        
    });
}

- (instancetype)rg_initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if ([self rg_initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self rg_updateSemanticContentAttribute];
    }
    return self;
}

- (instancetype)rg_initWithCoder:(NSCoder *)aDecoder {
    if ([self rg_initWithCoder:aDecoder]) {
        [self rg_updateSemanticContentAttribute];
    }
    return self;
}

- (instancetype)rg_initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    if ([self rg_initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        [self rg_updateSemanticContentAttribute];
    }
    return self;
}

- (instancetype)rg_initWithRootViewController:(UIViewController *)rootViewController {
    if ([self rg_initWithRootViewController:rootViewController]) {
        [self rg_updateSemanticContentAttribute];
    }
    return self;
}

- (void)rg_updateSemanticContentAttribute {
    if (@available(iOS 9.0, *)) {
        self.navigationBar.semanticContentAttribute = [UIView appearance].semanticContentAttribute;
        self.view.semanticContentAttribute = [UIView appearance].semanticContentAttribute;
        [self.navigationBar setNeedsLayout];
        [self.navigationBar setNeedsDisplay];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    objc_setAssociatedObject(self, rg_kOriginalDelegate, self.interactivePopGestureRecognizer.delegate, OBJC_ASSOCIATION_ASSIGN);
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(__interactivePopState:)];
}

- (void)__interactivePopState:(UIScreenEdgePanGestureRecognizer *)interactivePopGestureRecognizer {
    
    NSInteger result = -1;
    
    switch (interactivePopGestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            result = 1;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            result = 0;
            break;
        default:
            break;
    }
    
    if (result >= 0) {
        
        UIViewController *vc = objc_getAssociatedObject(self, rg_kInteractiveViewController);
        objc_setAssociatedObject(self, rg_kInteractiveViewController, 0, OBJC_ASSOCIATION_ASSIGN);
        
        [self interactivePopResultCallback:vc];
    }
}

- (void)interactivePopResultCallback:(UIViewController *)vc {
    UIView *animateView = vc.view;
    while (animateView && animateView.layer.animationKeys.count == 0) {
        animateView = animateView.superview;
    }
    
    if (!animateView) {
        if (vc && [vc conformsToProtocol:@protocol(RGUINavigationControllerShouldPopDelegate)]) {
            if ([vc respondsToSelector:@selector(rg_navigationController:interactivePopResult:)]) {
                [(id <RGUINavigationControllerShouldPopDelegate>)vc rg_navigationController:self interactivePopResult:self.topViewController != vc];
            }
        }
    } else {
        __block CGFloat duration = 0.f;
        [animateView.layer.animationKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CAAnimation *animation = [animateView.layer animationForKey:obj];
            duration = MAX(animation.duration, duration);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self interactivePopResultCallback:vc];
        });
    }
}

- (BOOL)rg_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController *vc = self.topViewController;
    if (item != vc.navigationItem) {
        return YES;
    }
    
    if ([vc conformsToProtocol:@protocol(RGUINavigationControllerShouldPopDelegate)]) {
        if ([vc respondsToSelector:@selector(rg_navigationControllerShouldPop:isInteractive:)]) {
            if ([(id <RGUINavigationControllerShouldPopDelegate>)vc rg_navigationControllerShouldPop:self isInteractive:NO]) {
                return [self rg_navigationBar:navigationBar shouldPopItem:item];
            } else {
                return NO;
            }
        }
    }
    return [self rg_navigationBar:navigationBar shouldPopItem:item];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        UIViewController *vc = self.topViewController;
        
        if ([vc conformsToProtocol:@protocol(RGUINavigationControllerShouldPopDelegate)]) {
            if ([vc respondsToSelector:@selector(rg_navigationControllerShouldPop:isInteractive:)]) {
                if (![(id <RGUINavigationControllerShouldPopDelegate>)vc rg_navigationControllerShouldPop:self isInteractive:YES]) {
                    return NO;
                }
            }
        }
        objc_setAssociatedObject(self, rg_kInteractiveViewController, vc, OBJC_ASSOCIATION_ASSIGN);
        id<UIGestureRecognizerDelegate> originalDelegate = objc_getAssociatedObject(self, rg_kOriginalDelegate);
        return [originalDelegate gestureRecognizerShouldBegin:gestureRecognizer];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        id<UIGestureRecognizerDelegate> originalDelegate = objc_getAssociatedObject(self, rg_kOriginalDelegate);
        return [originalDelegate gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        id<UIGestureRecognizerDelegate> originalDelegate = objc_getAssociatedObject(self, rg_kOriginalDelegate);
        return [originalDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return YES;
}

@end
