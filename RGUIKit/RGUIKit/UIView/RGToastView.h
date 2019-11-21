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

+ (RGToastView *)showWithInfo:(NSString *)info duration:(NSTimeInterval)duration percentY:(CGFloat)percentY inView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
