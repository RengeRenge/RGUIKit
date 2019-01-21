//
//  CTInputTableViewCell.h
//  CampTalk
//
//  Created by renge on 2018/5/12.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RGTableViewCell.h"

@class RGInputTableViewCell;

@protocol RGInputCellDelegate <UITextFieldDelegate>

- (void)rg_inputCellTextDidChange:(RGInputTableViewCell *)cell text:(NSString *)text;

@end

extern NSString * const RGInputTableViewCellID;

@interface RGInputTableViewCell : RGTableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) UIEdgeInsets textFieldEdge;

@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) UIEdgeInsets rightViewEdge;

@property (nonatomic, assign) BOOL hideLine;
@property (nonatomic, strong) UIColor *lineColor; // default textField.tintColor
@property (nonatomic, assign) UIEdgeInsets lineEdge;

@property (nonatomic, weak) id<RGInputCellDelegate> delegate;

- (NSString *)inputText;

@end
