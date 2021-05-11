//
//  JusLabelTableViewCell.m
//  JusCall
//
//  Created by juphoon on 2018/1/5.
//  Copyright © 2018年 Jus. All rights reserved.
//

#import "RGLabelTableViewCell.h"
#import <RGUIKit/RGUIKit.h>

NSString * const RGLabelTableViewCellID = @"RGLabelTableViewCellID";

@implementation RGLabelTableViewCell

+ (CGFloat)heightForText:(NSString *)text
                    font:(UIFont *)font
               tableView:(UITableView *)tableView
                textEdge:(UIEdgeInsets)textEdge
{
    return [self heightForText:text font:font tbWidth:CGRectGetWidth(tableView.frame) textEdge:textEdge];
}

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font tbWidth:(CGFloat)tbWidth textEdge:(UIEdgeInsets)textEdge {
    CGSize size = [text boundingRectWithSize:CGSizeMake(tbWidth - 50.f - textEdge.left - textEdge.right, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    
    return size.height + textEdge.top + textEdge.bottom;
}

+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText tableView:(UITableView *)tableView textEdge:(UIEdgeInsets)textEdge {
    return [self heightForAttributeText:attributeText tbWidth:CGRectGetWidth(tableView.frame) textEdge:textEdge];
}

+ (CGFloat)heightForAttributeText:(NSAttributedString *)attributeText tbWidth:(CGFloat)tbWidth textEdge:(UIEdgeInsets)textEdge {
    CGSize size = [attributeText boundingRectWithSize:CGSizeMake(tbWidth - textEdge.left - textEdge.right, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) context:nil].size;
    return size.height + textEdge.top + textEdge.bottom;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self __setup];
    }
    return self;
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithCustomStyle:style reuseIdentifier:reuseIdentifier]) {
        [self __setup];
    }
    return self;
}

- (void)__setup {
    _textEdgeMask = [[UIView alloc] init];
    _label = [[UILabel alloc] init];
    _label.numberOfLines = 0.f;
    _maskEdge = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:_textEdgeMask];
    [self.contentView addSubview:_label];
}

- (void)setText:(NSString *)text {
    _label.text = text;
    [self setNeedsLayout];
}

- (NSString *)text {
    return _label.text;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _label.attributedText = attributedText;
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedText {
    return _label.attributedText;
}

- (void)setLayoutStyle:(RGLabelTableViewCellLayoutStyle)layoutStyle {
    if (_layoutStyle != layoutStyle) {
        _layoutStyle = layoutStyle;
        [self setNeedsLayout];
    }
}

- (void)setTextEdge:(UIEdgeInsets)textEdge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_textEdge, textEdge)) {
        _textEdge = textEdge;
        [self setNeedsLayout];
    }
}

- (void)setMaskEdge:(UIEdgeInsets)maskEdge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_maskEdge, maskEdge)) {
        _maskEdge = maskEdge;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGSize size = CGSizeMake(CGRectGetWidth(bounds) - _textEdge.left - _textEdge.right, CGFLOAT_MAX);
    size = [_label sizeThatFits:size];
    
    CGRect frame;
    frame.size = size;
    frame.origin.y = _textEdge.top;
    if (_layoutStyle != RGLabelTableViewCellLayoutStyleNone) {
        if (_layoutStyle == RGLabelTableViewCellLayoutStyleCenterX ||
            _layoutStyle == RGLabelTableViewCellLayoutStyleCenterXY) {
            frame.origin.x = (bounds.size.width - size.width) / 2.f;
        }
        
        if (_layoutStyle == RGLabelTableViewCellLayoutStyleCenterY ||
            _layoutStyle == RGLabelTableViewCellLayoutStyleCenterXY) {
            frame.origin.y = (bounds.size.height - size.height) / 2.f;
        }
        
    } else {
        if (self.rg_layoutLeftToRight) {
            frame.origin.x = _textEdge.left;
        } else {
            frame.origin.x = bounds.size.width - _textEdge.left + size.width;
        }
    }
    _label.frame = frame;
    _textEdgeMask.frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-_maskEdge.top, -_maskEdge.left, -_maskEdge.bottom, -_maskEdge.right));
    
    [super subViewsDidLayoutForClass:RGLabelTableViewCell.class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
