//
//  CTInputTableViewCell.m
//  CampTalk
//
//  Created by renge on 2018/5/12.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import "RGInputTableViewCell.h"
#import <RGUIKit/RGUIKit.h>

NSString * const RGInputTableViewCellID = @"RGInputTableViewCellID";

@implementation RGInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute {
    [super setSemanticContentAttribute:semanticContentAttribute];
    self.textField.semanticContentAttribute = semanticContentAttribute;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawLine:rect];
}

- (void)drawLine:(CGRect)rect {
    if (_hideLine) {
        return;
    }
    
    rect = self.contentView.bounds;
    
    //  1.在此方法中系统已经创建一个与view相关联的上下文(layer上下文), 只要获取上下文就行;(获取和创建上下文都是UIGraphics开头)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.绘制路径(一条路径可以描述多条线)
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //    2.1 设置起点
    CGRect line =
    CGRectMake(_textFieldEdge.left,
               rect.size.height - 0.5,
               rect.size.width - _textFieldEdge.left - (_rightView ? _rightViewEdge.right : _textFieldEdge.right),
               0.5);
    line = UIEdgeInsetsInsetRect(line, _lineEdge);
    
    if (!self.rg_layoutLeftToRight) {
        line = [UIView rg_RTLFrameWithLTRFrame:line superWidth:self.bounds.size.width];
    }
    
    [path moveToPoint:CGPointMake(line.origin.x, line.origin.y)];
    [path addLineToPoint:CGPointMake(line.origin.x + line.size.width, line.origin.y)];
    
    //设置线的粗细
    CGContextSetLineWidth(ctx, line.size.height);
    
    //设置两根线的连接样式, 第二个参数是枚举
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //设置两根线各组尾部的样式, 第二个参数是枚举
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //    setStroke还是setFill看最终设定的渲染方式
    if (_lineColor) {
        [_lineColor setStroke];
    } else {
        [_textField.tintColor setStroke];
    }
    
    //3.把绘制的内容添加到上下文中
    //UIBezierPath是UIKit框架  第二个参数, CGPathRef是coreGraphic框架
    CGContextAddPath(ctx, path.CGPath);
    
    //4.把上下文渲染到view的layer上(stroke或fill的方式)
    CGContextStrokePath(ctx);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIEdgeInsets edge = _textFieldEdge;
    if (_rightView) {
        edge.right += self.rightView.frame.size.width;
        edge.right += (_rightViewEdge.left + _rightViewEdge.right);
    }
    
    self.textField.frame = UIEdgeInsetsInsetRect(self.contentView.bounds, edge);
    self.rightView.center = CGPointMake(CGRectGetMaxX(self.textField.frame) + _rightViewEdge.left + self.rightView.frame.size.width / 2.f, self.textField.center.y);
    
    if (!self.contentView.rg_layoutLeftToRight) {
        [self.textField rg_setFrameToFitRTL];
        [self.rightView rg_setFrameToFitRTL];
    }
    
    [super subViewsDidLayoutForClass:RGInputTableViewCell.class];
}

- (void)setTextFieldEdge:(UIEdgeInsets)textFieldEdge {
    if (UIEdgeInsetsEqualToEdgeInsets(textFieldEdge, _textFieldEdge)) {
        return;
    }
    _textFieldEdge = textFieldEdge;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setRightViewEdge:(UIEdgeInsets)rightViewEdge {
    _rightViewEdge = rightViewEdge;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setHideLine:(BOOL)hideLine {
    if (_hideLine == hideLine) {
        return;
    }
    _hideLine = hideLine;
    [self setNeedsDisplay];
}

- (void)setLineEdge:(UIEdgeInsets)lineEdge {
    if (UIEdgeInsetsEqualToEdgeInsets(lineEdge, _lineEdge)) {
        return;
    }
    _lineEdge = lineEdge;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:_textField];
    }
    return _textField;
}

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    if (rightView) {
        [self.contentView addSubview:rightView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDelegate:(id<RGInputCellDelegate>)delegate {
    _delegate = delegate;
    self.textField.delegate = delegate;
}

- (NSString *)inputText {
    if (_textField.text.length) {
        return _textField.text;
    }
    return @"";
}

- (void)textDidChange:(NSNotification *)noti {
    if ([self.delegate respondsToSelector:@selector(rg_inputCellTextDidChange:text:)]) {
        [self.delegate rg_inputCellTextDidChange:self text:self.textField.text];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
