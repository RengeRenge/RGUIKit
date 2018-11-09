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

@property (nonatomic, assign) UIEdgeInsets textEdge;

/// label layout at center
@property (nonatomic, assign) BOOL layoutCenter;

@property (nonatomic, strong) UIView *textEdgeMask;
@property (nonatomic, assign) UIEdgeInsets maskEdge;

+ (CGFloat)heightForText:(NSString *)text
                    font:(UIFont *)font
               tableView:(UITableView *)tableView
                textEdge:(UIEdgeInsets)textEdge;

+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText tableView:(UITableView *)tableView textEdge:(UIEdgeInsets)textEdge;

@end
