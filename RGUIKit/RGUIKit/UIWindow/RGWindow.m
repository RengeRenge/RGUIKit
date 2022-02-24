//
//  RGCommonWindow.m
//  XJCloud
//
//  Created by renge on 2020/11/18.
//  Copyright © 2020 ld. All rights reserved.
//

#import "RGWindow.h"
#import <RGUIKit/RGUIKit.h>

static NSString *rg_common_signle_scene_key = @"rg_common_signle_scene_key";

@interface RGWindowRootVC : UIViewController

@property (nonatomic, weak) RGWindow *window;

@end

@implementation RGWindowRootVC

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    RGWindow *window = self.window;
    if (window.addtionViewWillLayout) {
        window.addtionViewWillLayout(self, self.view.bounds);
    }
}

@end

@interface RGWindow ()

@property (nonatomic, assign) int randomTag;
@property (nonatomic, copy) void(^dismissAnimation)(void);
@property (nonatomic, copy) void(^dismissCompletion)(BOOL);
@property (nonatomic, copy) void(^blankClick)(RGWindow *window);

@property (nonatomic, weak) id createKey;
@property (nonatomic, weak) id sceneKey;

@property (nonatomic, weak) UIView *bgView;

@end

@implementation RGWindow

+ (NSMapTable <id, NSMapTable <id, RGWindow *> *>*)windowCache {
    static dispatch_once_t onceToken;
    static NSMapTable *windowCache = nil;
    dispatch_once(&onceToken, ^{
        windowCache = [NSMapTable weakToStrongObjectsMapTable];
    });
    return windowCache;
}

+ (RGWindow *)window {
    return [self windowCreateIfNeed:YES scene:nil createKey:nil];
}

+ (RGWindow *)windowWithCreateKey:(id)createKey {
    return [self windowCreateIfNeed:YES scene:nil createKey:createKey];
}

+ (RGWindow *)windowWithViewController:(UIViewController *)viewController {
    return [self windowWithViewController:viewController createKey:nil];
}

+ (RGWindow *)windowWithViewController:(UIViewController *)viewController createKey:(id)createKey {
    if (@available(iOS 13.0, *)) {
        if (!viewController) {
            return nil;
        }
        return [self windowWithScene:viewController.rg_scene createKey:createKey];
    } else {
        return [self windowCreateIfNeed:YES scene:nil createKey:createKey];
    }
}

+ (RGWindow *)windowWithScene:(UIScene *)scene  API_AVAILABLE(ios(13.0)) {
    return [self windowCreateIfNeed:YES scene:scene createKey:nil];
}

+ (RGWindow *)windowWithScene:(UIScene *)scene createKey:(id)createKey  API_AVAILABLE(ios(13.0)) {
    return [self windowCreateIfNeed:YES scene:scene createKey:createKey];
}

+ (RGWindow *)windowCreateIfNeed:(BOOL)create scene:(id)scene createKey:(id)createKey {
    RGWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        if (!scene) {
            scene = [UIScene rg_firstActiveWindowScene];
        }
        if (scene) {
            
            createKey = createKey ? createKey : scene;
            
            window = [[[self windowCache] objectForKey:scene] objectForKey:createKey];
            if (!window && create) {
                window = [[RGWindow alloc] initWithWindowScene:scene];
                [window setWindowLevel:UIWindowLevelAlert];
                
                window.createKey = createKey;
                window.sceneKey = scene;
                
                NSMapTable *sceneMap = [[self windowCache] objectForKey:scene];
                if (!sceneMap) {
                    sceneMap = [NSMapTable weakToStrongObjectsMapTable];
                    [[self windowCache] setObject:sceneMap forKey:scene];
                }
                [sceneMap setObject:window forKey:window.createKey];
            }
            return window;
        }
    }
    
    createKey = createKey ? createKey : UIApplication.sharedApplication;
    
    window = [[[self windowCache] objectForKey:UIApplication.sharedApplication] objectForKey:createKey];
    if (!window && create) {
        window = [[RGWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window setWindowLevel:UIWindowLevelAlert];
        
        window.createKey = createKey ? createKey : rg_common_signle_scene_key;
        window.sceneKey = rg_common_signle_scene_key;
        
        NSMapTable *sceneMap = [[self windowCache] objectForKey:rg_common_signle_scene_key];
        if (!sceneMap) {
            sceneMap = [NSMapTable weakToStrongObjectsMapTable];
            [[self windowCache] setObject:sceneMap forKey:rg_common_signle_scene_key];
        }
        [sceneMap setObject:window forKey:window.createKey];
    }
    return window;
}

+ (RGWindow *)findWindowWithCreateKey:(id)createKey {
    return [self windowCreateIfNeed:NO scene:nil createKey:createKey];
}

+ (RGWindow *)findWindowWithViewController:(UIViewController *)viewController createKey:(id)createKey {
    if (@available(iOS 13.0, *)) {
        return [self windowCreateIfNeed:NO scene:viewController.rg_scene createKey:createKey];
    } else {
        return [self windowCreateIfNeed:NO scene:nil createKey:createKey];
    }
}

+ (RGWindow *)findWindowWithScene:(UIScene *)scene createKey:(id)createKey {
    return [self windowCreateIfNeed:NO scene:scene createKey:createKey];
}

- (int)showWithAddtionView:(UIView *)view animation:(void (^)(void))animation completion:(void (^)(void))completion {
    [self reset:NO];
    _addtionView = view;
    self.randomTag = arc4random();
    
    if (view) {
        RGWindow *window = self;
        
        RGWindowRootVC *vc = nil;
        if (!window.rootViewController) {
            vc = [[RGWindowRootVC alloc] init];
            window.rootViewController = vc;
            vc.window = window;
        }
        
        [vc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        UIView *bgView = [[UIView alloc] initWithFrame:vc.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBlankClick)];
        [bgView addGestureRecognizer:tap];
        
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [vc.view addSubview:bgView];
        self.bgView = bgView;
        
        [vc.view addSubview:view];

        window.hidden = NO;
        
        [vc.view setNeedsLayout];
        [vc.view layoutIfNeeded];
        
        if (animation) {
            [UIView animateWithDuration:0.3 animations:animation completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        } else {
            if (completion) {
                completion();
            }
        }
    }
    return self.randomTag;
}

- (int)showWithViewController:(UIViewController *)viewController animation:(void (^)(void))animation completion:(void (^)(void))completion {
    [self reset:NO];
    self.randomTag = arc4random();
    
    if (viewController) {
        RGWindow *window = self;
        window.rootViewController = viewController;
        
        window.hidden = NO;
        
        [viewController.view setNeedsLayout];
        [viewController.view layoutIfNeeded];
        
        if (animation) {
            [UIView animateWithDuration:0.3 animations:animation completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        } else {
            if (completion) {
                completion();
            }
        }
    }
    return self.randomTag;
}

- (int)displayTag {
    return self.randomTag;
}

- (void)setAddtionViewWillLayout:(void (^)(UIViewController * _Nonnull, CGRect))addtionViewWillLayout {
    _addtionViewWillLayout = addtionViewWillLayout;
    if (addtionViewWillLayout && self.rootViewController) {
        addtionViewWillLayout(self.rootViewController, self.rootViewController.view.bounds);
    }
}

- (void)setDismissAnimation:(void (^)(void))animation completion:(void (^)(BOOL))completion {
    self.dismissAnimation = animation;
    self.dismissCompletion = completion;
}

- (void)dismissWithAnimation:(void (^)(void))animation completion:(void (^)(BOOL))completion {
    [self setDismissAnimation:animation completion:completion];
    [self dismiss];
}

- (void)dismiss {
    void(^ani)(void) = _dismissAnimation;
    void(^com)(BOOL) = _dismissCompletion;
    
    _dismissAnimation = nil;
    _dismissCompletion = nil;
    _blankClick = nil;
    
    int tag = _randomTag;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (ani) {
            ani();
        }
    } completion:^(BOOL finished) {
        if (tag != self.randomTag) {
            if (com) {com(NO);}
            return;
        }
        if (com) {com(YES);}
        if (self.createKey && self.sceneKey) {
            [[[self.class windowCache] objectForKey:self.sceneKey] removeObjectForKey:self.createKey];
        }
        [self reset:YES];
    }];
}

- (void)reset:(BOOL)hide {
    _randomTag = 0;
    _dismissAnimation = nil;
    _dismissCompletion = nil;
    _blankClick = nil;
    _addtionView = nil;
    
    if (hide) {
        self.hidden = YES;
        self.rootViewController = nil;
    }
}

- (void)onBlankClick {
    if (_blankClick) {
        _blankClick(self);
    }
}

- (void)setBlankClick:(void (^)(RGWindow * _Nonnull))blankClick {
    _blankClick = blankClick;
}

#pragma mark - window config

- (bool)_canAffectStatusBarAppearance {
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self || view == self.rootViewController.view) {
        return nil;
    }
    if (view == _bgView) {
        if (_touchThrough) {
            return nil;
        }
        if (!_blankClick) {
            return nil;
        }
    }
    return view;
}

@end
