//
//  TableViewCell.h
//  JusTalk
//
//  Created by Cathy on 14/11/24.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const RGTableViewCellDefaultIconDimension;

extern NSString * const RGCellID; // UITableViewCellStyleSubtitle
extern NSString * const RGCellIDValue1; // UITableViewCellStyleValue1
extern NSString * const RGCellIDValue2; // UITableViewCellStyleValue2
extern NSString * const RGCellIDValueDefault; // UITableViewCellStyleDefault

@interface RGTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL applyThemeColor;
/// 按下时的背景颜色    applyThemeColor 为 YES 的时候无效，优先使用主题色
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@property (nonatomic, assign, readonly) UITableViewCellStyle cellStyle;

@property (nonatomic, strong) UIColor *detailTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) void(^selectedBlock)(__kindof RGTableViewCell *cell, BOOL selected, BOOL animated);
@property (nonatomic, copy) void(^highlightedBlock)(__kindof RGTableViewCell *cell, BOOL highlighted, BOOL animated);

/// 继承 RGTableViewCell 的类如果重写了 layoutSubviews 需要在最后调用一下 subViewsDidLayoutForClass, 以保证 layoutSubviewsBlock 能在正确的时机回调
@property (nonatomic, copy) void(^layoutSubviewsBlock)(__kindof RGTableViewCell *cell, CGRect bounds);


- (void)subViewsDidLayoutForClass:(Class)subClass;


/**
 初始化cell 自定义 UITableViewCellStyle
 */
- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


/**
 获取复用的 cell 没有则初始化一个
 */
+ (instancetype)dequeueCellWithIdentifier:(NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(UITableView *)tableView;


/**
 全局设置 cell 的主题色 影响按下颜色
 */
+ (void)setThemeColor:(UIColor *)color;

@end
