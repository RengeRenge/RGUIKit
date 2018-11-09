//
//  CornerCell.h
//  JusTalk
//
//  Created by juphoon on 2017/12/8.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "RGIconCell.h"

extern NSString * const RGCornerTableViewCellID;

@interface RGCornerTableViewCell : RGIconCell

@property (nonatomic, assign) UIRectCorner corner;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat verticalOffSet;

@end
