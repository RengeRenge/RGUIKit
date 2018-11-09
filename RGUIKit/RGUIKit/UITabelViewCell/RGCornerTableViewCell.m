//
//  CornerCell.m
//  JusTalk
//
//  Created by juphoon on 2017/12/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "RGCornerTableViewCell.h"

NSString * const RGCornerTableViewCellID = @"RGCornerTableViewCellID";

@interface RGCornerTableViewCell ()

@end

@implementation RGCornerTableViewCell

- (void)setCorner:(UIRectCorner)corner {
    _corner = corner;
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}

- (void)setVerticalOffSet:(CGFloat)verticalOffSet {
    _verticalOffSet = verticalOffSet;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    bounds.origin.y = -_verticalOffSet;
    self.contentView.bounds = bounds;
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectIntegral(self.bounds) byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.strokeColor = [UIColor whiteColor].CGColor;
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

@end
