//
//  JusEdgeTableViewCell.h
//  JusCall
//
//  Created by juphoon on 2018/1/9.
//  Copyright © 2018年 Jus. All rights reserved.
//

#import "RGIconCell.h"

extern NSString * const RGEdgeTableViewCellID;

typedef enum : NSUInteger {
    RGEdgeCellSeparatorStyleNone,
    RGEdgeCellSeparatorStyleDefault,
    RGEdgeCellSeparatorStyleCenter,
    RGEdgeCellSeparatorStyleFull,
} RGEdgeCellSeparatorStyle;

typedef enum : NSUInteger {
    RGEdgeCellRightLabelStyleCenter,
    RGEdgeCellRightLabelStyleTop,
} RGEdgeCellRightLabelStyle;

@interface RGEdgeTableViewCell : RGIconCell

@property (nonatomic, assign) UIEdgeInsets edge; // 当使用 删除 或者 accessoryView 的时候，不要使用
@property (nonatomic, assign) BOOL edgeEnable; // default NO

@property (nonatomic, assign) UIEdgeInsets customSeparatorEdge;
@property (nonatomic, assign) RGEdgeCellSeparatorStyle customSeparatorStyle;
@property (nonatomic, strong) UIView *customSeparatorView;

@property (nonatomic, assign) UIEdgeInsets rightLabelEdge;
@property (nonatomic, assign) RGEdgeCellRightLabelStyle rightLabelStyle;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, assign) BOOL highlightedEnable;

@property (nonatomic, strong) CALayer *showdowLayer; // default Hidden

@property (nonatomic, strong) CAShapeLayer *roundedLayer;
@property (nonatomic, assign) UIRectCorner contentCorner;
@property (nonatomic, assign) CGFloat contentCornerRadius;

@end
