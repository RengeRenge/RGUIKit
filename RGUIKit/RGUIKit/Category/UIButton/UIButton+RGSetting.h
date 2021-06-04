//
//  UIButton+RGSetting.h
//  RGUIKit
//
//  Created by renge on 2021/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton(RGSetting)

- (void)rg_setTitle:(NSString *)title forState:(UIControlState)state animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
