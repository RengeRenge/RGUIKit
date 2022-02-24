//
//  RGCommonWindow.h
//  XJCloud
//
//  Created by renge on 2020/11/18.
//  Copyright © 2020 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGWindow : UIWindow

+ (RGWindow * _Nullable)window;
+ (RGWindow * _Nullable)windowWithViewController:(UIViewController *)viewController;
+ (RGWindow * _Nullable)windowWithScene:(UIScene *)scene API_AVAILABLE(ios(13.0));

+ (RGWindow * _Nullable)windowWithCreateKey:(id _Nullable)createKey;
+ (RGWindow * _Nullable)windowWithViewController:(UIViewController *)viewController createKey:(id _Nullable)createKey;
+ (RGWindow * _Nullable)windowWithScene:(UIScene *)scene createKey:(id _Nullable)createKey API_AVAILABLE(ios(13.0));

+ (RGWindow * _Nullable)findWindowWithCreateKey:(id _Nullable)createKey;
+ (RGWindow * _Nullable)findWindowWithViewController:(UIViewController *)viewController createKey:(id _Nullable)createKey;
+ (RGWindow * _Nullable)findWindowWithScene:(UIScene *)scene createKey:(id _Nullable)createKey API_AVAILABLE(ios(13.0));

@property (nonatomic, weak, readonly, nullable) UIView *addtionView;
@property (nonatomic, copy, nullable) void(^addtionViewWillLayout)(UIViewController *viewController, CGRect bounds);
- (int)showWithAddtionView:(UIView *)view animation:(void(^_Nullable)(void))animation completion:(void(^_Nullable)(void))completion;

- (int)showWithViewController:(UIViewController *)viewController animation:(void(^_Nullable)(void))animation completion:(void(^_Nullable)(void))completion;

- (void)dismiss;
- (void)setDismissAnimation:(void(^_Nullable)(void))animation completion:(void(^_Nullable)(BOOL finished))completion;
- (void)dismissWithAnimation:(void(^_Nullable)(void))animation completion:(void(^_Nullable)(BOOL finished))completion;

- (int)displayTag;

@property (nonatomic, assign) BOOL touchThrough;
- (void)setBlankClick:(void(^_Nullable)(RGWindow *window))blankClick;

@end

NS_ASSUME_NONNULL_END
