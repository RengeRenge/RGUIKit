//
//  UITextField+RGTextOB.h
//  RGUIKit
//
//  Created by renge on 2020/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RGTextFieldDelegate <NSObject>

- (void)textField:(UITextField *)textField textDidChange:(NSString *)text;

@end

@interface UITextField(RGTextOB)

@property (nonatomic, weak) id <RGTextFieldDelegate> rg_delegate;

@end

NS_ASSUME_NONNULL_END
