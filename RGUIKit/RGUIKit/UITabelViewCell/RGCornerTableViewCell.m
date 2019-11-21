//
//  CornerCell.m
//  JusTalk
//
//  Created by juphoon on 2017/12/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "RGCornerTableViewCell.h"

NSString * const RGCornerTableViewCellID = @"RGCornerTableViewCellID";

@interface RGCornerTableViewCell () {
    CAShapeLayer *shape;
}

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

- (void)layoutSubviews {
    [super layoutSubviews];
    UIRectCorner corner = self.corner;
    if ((corner & UIRectCornerTopLeft ||
         corner & UIRectCornerTopRight ||
         corner & UIRectCornerBottomLeft ||
         corner & UIRectCornerBottomRight ||
         corner & UIRectCornerAllCorners) &&
        self.cornerRadius > 0) {
        if (!shape) {
            shape =  [[CAShapeLayer alloc] init];
            shape.strokeColor = [UIColor whiteColor].CGColor;
        }
        
        UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectIntegral(self.bounds) byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
        shape.path = rounded.CGPath;
        self.layer.mask = shape;
    } else {
        self.layer.mask = nil;
    }
    [super subViewsDidLayoutForClass:RGCornerTableViewCell.class];
}

@end
