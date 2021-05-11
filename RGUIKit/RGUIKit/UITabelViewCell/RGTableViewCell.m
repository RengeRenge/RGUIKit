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
NSString * const RGCellIDSubtitle = RGCellID;
NSString * const RGCellIDValue1 = @"RGCellIDValue1";
NSString * const RGCellIDValue2 = @"RGCellIDValue2";
NSString * const RGCellIDDefault = @"RGCellIDDefault";

NSString *const kRGTableViewCellThemeColorDidChangeNotification = @"kRGTableViewCellThemeColorDidChangeNotification";

static UIColor * kRGTableViewCellThemeColor;

@interface RGTableViewCell ()

@property (nonatomic, strong) UIColor *lastThemeColor;
@property (nonatomic, strong) UIView *themeBackgroundView;

@end

@implementation RGTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([reuseIdentifier hasPrefix:RGCellIDSubtitle]) {
        style = UITableViewCellStyleSubtitle;
    } else if ([reuseIdentifier hasPrefix:RGCellIDValue1]) {
        style = UITableViewCellStyleValue1;
    } else if ([reuseIdentifier hasPrefix:RGCellIDValue2]) {
        style = UITableViewCellStyleValue2;
    }
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellStyle = style;
        [self configView];
    }
    return self;
}

+ (instancetype)cellWithCustomStyle:(UITableViewCellStyle)style {
    return [[self alloc] initWithCustomStyle:style];
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style {
    return [self initWithCustomStyle:style reuseIdentifier:nil];
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellStyle = style;
         [self configView];
    }
    return self;
}

+ (instancetype)dequeueCellWithIdentifier:(NSString *)reuseIdentifier style:(UITableViewCellStyle)style tableView:(UITableView *)tableView {
    RGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell || ![cell isKindOfClass:RGTableViewCell.class] || cell.cellStyle != style) {
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
    _markHeight = UITableViewAutomaticDimension;
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

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    [self themeColorChanged];
}

- (void)themeColorChanged {
    
    if (!self.applyThemeColor && !_selectedBackgroundColor) {
        return;
    }
    
    [self setCustomBackgroundIfNeed];
    
    self.tintColor = kRGTableViewCellThemeColor;
    UIView *backgroundView = self.selectedBackgroundView;
    
    // 优先使用主题色
    if (self.applyThemeColor) {
        backgroundView.backgroundColor = [kRGTableViewCellThemeColor colorWithAlphaComponent:0.3f];
    } else {
        backgroundView.backgroundColor = _selectedBackgroundColor;
    }
    
    [self setSelectedBackgroundView:backgroundView];
    self.lastThemeColor = kRGTableViewCellThemeColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self subViewsDidLayoutForClass:RGTableViewCell.class];
}

- (void)subViewsDidLayoutForClass:(Class)subClass {
    if (self.layoutSubviewsBlock) {
        
        if (subClass == self.class) {
            self.layoutSubviewsBlock(self, self.contentView.bounds);
            return;
        }
        
        // find lastLayoutImpClass
        Class superClass = self.class.superclass;
        Class lastLayoutImpClass = RGTableViewCell.class;
        
        IMP imp1 = [superClass instanceMethodForSelector:@selector(layoutSubviews)];
        IMP imp2 = [self.class instanceMethodForSelector:@selector(layoutSubviews)];
        
        if (imp1 != imp2) { // self.class exist layoutSubviews IMP
            lastLayoutImpClass = self.class;
        } else {
            // find lastLayoutImpClass
            Class nowClass = self.class;
            while (nowClass != UITableViewCell.class) {
                superClass = nowClass.superclass;
                imp1 = [nowClass instanceMethodForSelector:@selector(layoutSubviews)];
                imp2 = [superClass instanceMethodForSelector:@selector(layoutSubviews)];
                if (imp1 != imp2) {
                    lastLayoutImpClass = nowClass;
                    break;
                } else {
                    nowClass = nowClass.superclass;
                }
            }
        }
        if (subClass == lastLayoutImpClass) {
            self.layoutSubviewsBlock(self, self.contentView.bounds);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selectedBlock) {
        self.selectedBlock(self, selected, animated);
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlightedBlock) {
        self.highlightedBlock(self, highlighted, animated);
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.selectedBlock = nil;
    self.highlightedBlock = nil;
    self.layoutSubviewsBlock = nil;
}

- (void)dealloc {
    self.selectedBlock = nil;
    self.highlightedBlock = nil;
    self.layoutSubviewsBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

