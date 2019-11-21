//
//  JusEdgeTableViewCell.m
//  JusCall
//
//  Created by juphoon on 2018/1/9.
//  Copyright © 2018年 Jus. All rights reserved.
//

#import "RGEdgeTableViewCell.h"
#import "UIView+RGLayoutHelp.h"

NSString * const RGEdgeTableViewCellID = @"RGEdgeTableViewCellID";

#define kJusEdgeCellRightLabelTaringOffset (9)
#define kJusEdgeCellDetailLabelTaringOffset (16)

@interface RGEdgeTableViewCell ()

@property (nonatomic, strong) UIColor *hightedColor;
@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, assign) BOOL roundedChanged;

@property (nonatomic, assign) UIEdgeInsets edgeRTL;

@property (nonatomic, strong) UIView *rg_accessoryView;

@end

@implementation RGEdgeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rightLabel];
        [self addSubview:self.customSeparatorView];
        CGFloat rgb = 217.f/255.f;
        _hightedColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.f];
        _contentCorner = UIRectCornerAllCorners;
        self.accessoryType = self.accessoryType;
    }
    return self;
}

- (UIView *)rg_accessoryView {
    if (!_rg_accessoryView) {
        _rg_accessoryView = [[UIView alloc] init];
        _rg_accessoryView.userInteractionEnabled = NO;
    }
    return _rg_accessoryView;
}

- (CALayer *)showdowLayer {
    if (!_showdowLayer) {
        _showdowLayer = [CALayer layer];
        _showdowLayer.frame = self.contentView.frame;
        _showdowLayer.shadowOffset = CGSizeMake(0, 1);
        _showdowLayer.shadowRadius = 1.0;
        _showdowLayer.shadowColor = [UIColor blackColor].CGColor;
        _showdowLayer.shadowOpacity = 0.12;
        _showdowLayer.hidden = YES;
        [self.layer insertSublayer:_showdowLayer atIndex:0];
    }
    return _showdowLayer;
}

- (CAShapeLayer *)roundedLayer {
    if (!_roundedLayer) {
        _roundedLayer = [[CAShapeLayer alloc] init];
        _roundedLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _roundedLayer;
}

- (UIView *)customSeparatorView {
    if (!_customSeparatorView) {
        _customSeparatorView = [[UIView alloc] init];
        _customSeparatorView.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.f];
    }
    return _customSeparatorView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _rightLabel;
}

- (void)setEdge:(UIEdgeInsets)edge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_edge, edge)) {
        _edge = edge;
        _edgeRTL = edge;
        _edgeRTL.left = edge.right;
        _edgeRTL.right = edge.left;
        _edgeEnable = YES;
        self.accessoryType = self.accessoryType;
        [self setNeedsLayout];
    }
}

- (void)setEdgeEnable:(BOOL)edgeEnable {
    if (_edgeEnable != edgeEnable) {
        _edgeEnable = edgeEnable;
        [self setNeedsLayout];
    }
}

- (void)setCustomSeparatorEdge:(UIEdgeInsets)customSeparatorEdge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_customSeparatorEdge, customSeparatorEdge)) {
        _customSeparatorEdge = customSeparatorEdge;
        [self setNeedsLayout];
    }
}

- (void)setRightLabelEdge:(UIEdgeInsets)rightLabelEdge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_rightLabelEdge, rightLabelEdge)) {
        _rightLabelEdge = rightLabelEdge;
        [self setNeedsLayout];
    }
}

- (void)setContentCorner:(UIRectCorner)contentCorner {
    _contentCorner = contentCorner;
    _roundedChanged = YES;
    [self setNeedsLayout];
}

- (void)setContentCornerRadius:(CGFloat)contentCornerRadius {
    _contentCornerRadius = contentCornerRadius;
    _roundedChanged = YES;
    [self setNeedsLayout];
}

- (void)setCustomSeparatorStyle:(RGEdgeCellSeparatorStyle)customSeparatorStyle {
    if (customSeparatorStyle != _customSeparatorStyle) {
        _customSeparatorStyle = customSeparatorStyle;
        [self setNeedsLayout];
    }
}

- (UIEdgeInsets)currentEdge {
    if (self.rg_layoutLeftToRight) {
        return _edge;
    }
    return _edgeRTL;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = [self currentEdge];
    
    CGRect bounds;
    if (_edgeEnable) {
        self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, edge);
        bounds = self.contentView.frame;
        bounds.origin.y = edge.top;
        bounds.origin.x = 0.f;
    } else {
        bounds = self.contentView.bounds;
    }
    
    self.contentView.bounds = bounds;
    
    _roundedLayer = nil;
    CGPathRef roundedPathRef = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:_contentCorner cornerRadii:CGSizeMake(_contentCornerRadius, _contentCornerRadius)].CGPath;
    [self.roundedLayer setPath:roundedPathRef];
    self.contentView.layer.mask = self.roundedLayer;
    
    if (_roundedChanged || !CGRectEqualToRect(_showdowLayer.frame, self.contentView.frame)) {
        _showdowLayer.frame = self.contentView.frame;
        self.showdowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.showdowLayer.bounds cornerRadius:self.contentCornerRadius].CGPath;
    }
    
    _roundedChanged = NO;
    
    // layout
    
    
    /*------- label ------*/
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    [self.rightLabel sizeToFit];
    CGRect titleFrame = self.textLabel.frame;
    CGRect detailFrame = self.detailTextLabel.frame;
    
    CGRect rightFrame = self.rightLabel.frame;
    switch (_rightLabelStyle) {
        case RGEdgeCellRightLabelStyleTop:
            rightFrame.origin.y = 0;
            break;
        case RGEdgeCellRightLabelStyleCenter:
            default:
            rightFrame.origin.y = (CGRectGetHeight(bounds) - rightFrame.size.height) / 2.f;
            break;
    }
    
    CGFloat rightLabelTaringOffset = kJusEdgeCellRightLabelTaringOffset;
    if (self.rg_layoutLeftToRight) {
        rightFrame.origin.x = bounds.size.width - rightFrame.size.width - rightLabelTaringOffset;
    } else {
        rightFrame.origin.x = rightLabelTaringOffset;
        
        CGFloat rightLabelMaxX = CGRectGetMaxX(rightFrame);
        titleFrame.origin.x = rightLabelMaxX + kJusEdgeCellDetailLabelTaringOffset;
        detailFrame.origin.x = rightLabelMaxX + kJusEdgeCellDetailLabelTaringOffset;
    }
    CGFloat rightLabelSpace = rightFrame.size.width + rightLabelTaringOffset + kJusEdgeCellDetailLabelTaringOffset;
    CGFloat titleMaxLength = bounds.size.width - self.separatorInset.left + _edge.left - rightLabelSpace;
    titleFrame.size.width = titleMaxLength;
    detailFrame.size.width = titleMaxLength;
    
    if (!self.detailTextLabel.text || self.detailTextLabel.text.length == 0) {
        titleFrame.origin.y = (bounds.size.height - titleFrame.size.height) / 2.0f + bounds.origin.y;
    }
    
    self.textLabel.frame = titleFrame;
    self.detailTextLabel.frame = detailFrame;
    self.rightLabel.frame = UIEdgeInsetsInsetRect(rightFrame, _rightLabelEdge);
    
    /*------- separatorInset ------*/
    CGFloat originX = self.separatorInset.left;
    CGFloat lineWidth = bounds.size.width - originX + _edge.left;
    
    CGRect frame = CGRectMake(originX, CGRectGetMaxY(self.contentView.frame) - 0.5f, lineWidth, 0.5f);
    switch (_customSeparatorStyle) {
        case RGEdgeCellSeparatorStyleDefault:
            break;
        case RGEdgeCellSeparatorStyleCenter:
            frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, -(self.separatorInset.left -self.iconSize.width), 0, self.iconSize.width));
            break;
        case RGEdgeCellSeparatorStyleFull:
            frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(0, -self.separatorInset.left, 0, -self.separatorInset.right));
            break;
        default:
            break;
    }
    frame = UIEdgeInsetsInsetRect(frame, _customSeparatorEdge);
    _customSeparatorView.frame = frame;
    
    if (!self.rg_layoutLeftToRight) {
        [_customSeparatorView rg_setFrameToFitRTL];
    }
    
    [super subViewsDidLayoutForClass:RGEdgeTableViewCell.class];
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    [super setAccessoryType:accessoryType];
    if (accessoryType == UITableViewCellAccessoryNone) {
        if (self.accessoryView == _rg_accessoryView) {
            self.rg_accessoryView.frame = CGRectMake(0, 0, _edge.left, 20);
            self.accessoryView = self.rg_accessoryView;
        }
    } else {
        self.accessoryView = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIView *view = UIEdgeInsetsEqualToEdgeInsets(_edge, UIEdgeInsetsZero) ? self : self.contentView;
    
    if (_highlightedEnable && self.selected != selected) {
        void(^config)(BOOL state) = ^(BOOL state){
            if (state) {
                if (!self->_normalColor || ![self->_normalColor isEqual:self->_hightedColor]) {
                    self->_normalColor = view.backgroundColor;
                }
                [view setBackgroundColor:self->_hightedColor];
                self->_customSeparatorView.alpha = 0.0f;
            } else {
                [view setBackgroundColor:self->_normalColor];
                self->_customSeparatorView.alpha = 1.0f;
            }
        };
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                config(selected);
            } completion:^(BOOL finished) {
                config(self.selected);
            }];
        } else {
            config(selected);
        }
    }
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIView *view = UIEdgeInsetsEqualToEdgeInsets(_edge, UIEdgeInsetsZero) ? self : self.contentView;
    
    if (_highlightedEnable && highlighted != self.highlighted) {
        void(^config)(BOOL state) = ^(BOOL state) {
            if (state) {
                if (!self->_normalColor || ![self->_normalColor isEqual:self->_hightedColor]) {
                    self->_normalColor = view.backgroundColor;
                }
                [view setBackgroundColor:self->_hightedColor];
                self->_customSeparatorView.alpha = 0.0f;
            } else {
                [view setBackgroundColor:self->_normalColor];
                self->_customSeparatorView.alpha = 1.0f;
            }
        };
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                config(highlighted);
            } completion:^(BOOL finished) {
                config(self.highlighted);
            }];
        } else {
            config(highlighted);
        }
    }
    [super setHighlighted:highlighted animated:animated];
}

@end

