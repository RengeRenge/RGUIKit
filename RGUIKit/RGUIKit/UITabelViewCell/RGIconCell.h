//
//  IconCell.h
//  JusTalk
//
//  Created by LD on 2016/10/21.
//  Copyright © 2016年 juphoon. All rights reserved.
//

#import "RGTableViewCell.h"
#import "UIImage+RGIconCell.h"

@interface RGIconCell <__covariant RGIconCellCustomIcon> : RGTableViewCell

/// config customIcon
- (void)configCustomIcon:(RGIconCellCustomIcon _Nullable (^_Nullable)(RGIconCellCustomIcon _Nullable icon))config;

/// 设置自定义的图标视图，视图会被自动添加到 contentView 上，视图的大小为 iconSize
@property (nonatomic, strong) RGIconCellCustomIcon _Nullable customIcon;

/// RGIconCell will not enlarge the Icon
@property (nonatomic, assign) RGIconResizeMode iconResizeMode;

/// default TableViewCellDefaultIconDimension x TableViewCellDefaultIconDimension (40x40)
@property (nonatomic, assign) CGSize iconSize;

/// defalut YES
@property (nonatomic, assign) BOOL iconCornerRound;

/// defalut nil
@property (nonatomic, strong) UIColor * _Nullable iconBackgroundColor;

/// default NO
@property (nonatomic, assign) BOOL adjustIconBackgroundWhenHighlighted;

/// get icon cell
+ (__kindof RGIconCell * _Nonnull)getCell:(UITableView * _Nonnull)tableView reuseIdentifier:(NSString * _Nullable)reuseIdentifier;

/// reset cell
- (void)resetConfig;

@end
