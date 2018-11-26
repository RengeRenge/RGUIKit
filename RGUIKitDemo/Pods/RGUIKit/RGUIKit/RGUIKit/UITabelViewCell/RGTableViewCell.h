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

@property (nonatomic, strong) UIColor *detailTextColor UI_APPEARANCE_SELECTOR;

/// 初始化cell 自定义 UITableViewCellStyle
- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/// 获取复用的 cell 没有则初始化一个
+ (instancetype)dequeueCellWithIdentifier:(NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(UITableView *)tableView;

+ (void)setThemeColor:(UIColor *)color;

@end
