//
//  TableViewCell.h
//  JusTalk
//
//  Created by Cathy on 14/11/24.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTableViewCellID;
extern CGFloat const RGTableViewCellDefaultIconDimension;

@interface RGTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL applyThemeColor;

+ (void)setThemeColor:(UIColor *)color;

@end
