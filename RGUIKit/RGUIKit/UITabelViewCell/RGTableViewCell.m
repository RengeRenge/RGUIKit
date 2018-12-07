//
//  TableViewCell.m
//  JusTalk
//
//  Created by Cathy on 14/11/24.
//  Copyright (c) 2014年 juphoon. All rights reserved.
//

#import "RGTableViewCell.h"

CGFloat const RGTableViewCellDefaultIconDimension = 40.f;

NSString * const RGCellID = @"RGCellIDSubtitle";
NSString * const RGCellIDValue1 = @"RGCellIDValue1";
NSString * const RGCellIDValue2 = @"RGCellIDValue2";
NSString * const RGCellIDValueDefault = @"RGCellIDValueDefault";

NSString *const kRGTableViewCellThemeColorDidChangeNotification = @"kRGTableViewCellThemeColorDidChangeNotification";

static UIColor * kRGTableViewCellThemeColor;

@interface RGTableViewCell ()

@property (nonatomic, strong) UIColor *lastThemeColor;
@property (nonatomic, strong) UIView *themeBackgroundView;

@end

@implementation RGTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([reuseIdentifier hasPrefix:RGCellID]) {
        style = UITableViewCellStyleSubtitle;
    } else if ([reuseIdentifier hasPrefix:RGCellIDValue1]) {
        style = UITableViewCellStyleValue1;
    } else if ([reuseIdentifier hasPrefix:RGCellIDValue2]) {
        style = UITableViewCellStyleValue2;
    }
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configView];
    }
    return self;
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self configView];
    }
    return self;
}

+ (instancetype)dequeueCellWithIdentifier:(NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(UITableView *)tableView {
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        return [[self alloc] initWithCustomStyle:style reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)setDetailTextColor:(UIColor *)detailTextColor {
    _detailTextColor = detailTextColor;
    self.detailTextLabel.textColor = detailTextColor;
}

+ (void)setThemeColor:(UIColor *)color {
    kRGTableViewCellThemeColor = [color copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRGTableViewCellThemeColorDidChangeNotification object:nil];
}

- (void)configView {
    if (!_detailTextColor) {
        _detailTextColor = [UIColor lightGrayColor];
    }
    self.detailTextLabel.textColor = _detailTextColor;
//    self.backgroundColor = [UIColor whiteColor];
    
    [self themeColorChanged];
    
    [self updateFontSizeWhenContentSizeChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeColorChanged) name:kRGTableViewCellThemeColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFontSizeWhenContentSizeChanged) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)setCustomBackgroundIfNeed {
    if (kRGTableViewCellThemeColor) {
        if (!self.themeBackgroundView) {
            self.themeBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
            [self setSelectedBackgroundView:self.themeBackgroundView];
        }
    } else {
        self.themeBackgroundView = nil;
        [self setSelectedBackgroundView:nil];
    }
}

- (void)updateFontSizeWhenContentSizeChanged {
    self.textLabel.font = [UIFont systemFontOfSize:17.f];
//    self.textLabel.textColor = [Settings primaryTextColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
//    self.detailTextLabel.textColor = [Settings secondaryTextColor];
}

- (void)setApplyThemeColor:(BOOL)applyThemeColor {
    if (_applyThemeColor == applyThemeColor) {
        return;
    }
    _applyThemeColor = applyThemeColor;
    [self themeColorChanged];
}

- (void)themeColorChanged {
    
    if (!self.applyThemeColor) {
        return;
    }
    
    [self setCustomBackgroundIfNeed];
    
    self.tintColor = kRGTableViewCellThemeColor;
    UIView *backgroundView = self.selectedBackgroundView;
    backgroundView.backgroundColor = [kRGTableViewCellThemeColor colorWithAlphaComponent:0.3f];
    [self setSelectedBackgroundView:backgroundView];
    self.lastThemeColor = kRGTableViewCellThemeColor;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

