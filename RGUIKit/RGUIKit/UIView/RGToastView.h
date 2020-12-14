//
//  RGToastView.h
//  RGUIKit
//
//  Created by renge on 2019/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RGToastView : UIView

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY;
+ (void)dismiss;

/// show toast for UIScene; find scene by viewController.
+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY viewController:(UIViewController *)viewController;
/// hide toast adapt for UIScene; find scene by viewController.
+ (void)dismissWithViewController:(UIViewController *)viewController;

+ (void)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY scene:(UIScene *)scene API_AVAILABLE(ios(13.0));
+ (void)dismissWithScene:(UIScene *)scene API_AVAILABLE(ios(13.0));

+ (RGToastView *)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY inView:(UIView *)view;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
