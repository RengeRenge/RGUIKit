//
//  JusLabelTableViewCell.h
//  JusCall
//
//  Created by juphoon on 2018/1/5.
//  Copyright © 2018年 Jus. All rights reserved.
//

#import "RGTableViewCell.h"

extern NSString * const RGLabelTableViewCellID;

@interface RGLabelTableViewCell : RGTableViewCell

@property (nonatomic, strong) UILabel *label;

/// 距离contentView边距的配置 .left.right 距离 contentView 左右边最小的距离; .top 顶部的距离
@property (nonatomic, assign) UIEdgeInsets textEdge;

/// label layout at center
@property (nonatomic, assign) BOOL layoutCenter;

@property (nonatomic, strong) UIView *textEdgeMask;
/// 以文字的 frame 为基准进行扩张
@property (nonatomic, assign) UIEdgeInsets maskEdge;

- (void)setText:(NSString *)text;
- (void)setAttributedText:(NSAttributedString *)attributedText;

+ (CGFloat)heightForText:(NSString *)text
                    font:(UIFont *)font
               tableView:(UITableView *)tableView
                textEdge:(UIEdgeInsets)textEdge;

+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText tableView:(UITableView *)tableView textEdge:(UIEdgeInsets)textEdge;

@end
