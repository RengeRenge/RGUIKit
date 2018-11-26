//
//  IconCell.m
//  JusTalk
//
//  Created by LD on 2016/10/21.
//  Copyright © 2016年 juphoon. All rights reserved.
//

#import "RGIconCell.h"
#import "UIImage+RGTint.h"
#import "UIView+RGLayoutHelp.h"

#define textLabelFont       [UIFont systemFontOfSize:16.0f]
#define detailTextLabelFont [UIFont systemFontOfSize:12.0f];
#define accessoryButtonFont [UIFont systemFontOfSize:15.0f];

#define kDefaultIconSize CGSizeMake(RGTableViewCellDefaultIconDimension, RGTableViewCellDefaultIconDimension)

@interface RGIconCell () {
    UIImageView *_fakeImageView;
}

@end

@implementation RGIconCell

+ (RGIconCell *)getCell:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    RGIconCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[RGIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self resetConfig];
    }
    return self;
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithCustomStyle:style reuseIdentifier:reuseIdentifier]) {
        [self resetConfig];
    }
    return self;
}

- (void)setCustomIcon:(UIView *)customIcon {
    if (_customIcon != customIcon) {
        [_customIcon removeFromSuperview];
        _customIcon = customIcon;
        if (_customIcon) {
            self.imageView.hidden = YES;
            [self.contentView addSubview:_customIcon];
            [self setNeedsLayout];
        } else {
            self.imageView.hidden = NO;
        }
    }
}

- (void)configCustomIcon:(id (^)(id))config {
    if (config) {
        UIView *customIcon = config(self.customIcon);
        if ([customIcon isKindOfClass:UIView.class]) {
            self.customIcon = customIcon;
        }
    }
}

- (void)setIconSize:(CGSize)iconSize {
    _iconSize = iconSize;
    CGRect frame = _fakeImageView.frame;
    frame.size = iconSize;
    _fakeImageView.frame = frame;
    if (!CGSizeEqualToSize(_iconSize, [super imageView].image.size)) {
        [super imageView].contentMode = UIViewContentModeCenter;
        [super imageView].image = [UIImage rg_coloredImage:[UIColor clearColor] size:_iconSize];
        [self setNeedsLayout];
    }
}

- (void)resetConfig {
    _iconResizeMode = RGIconResizeModeScaleAspectFill;
    _iconCornerRound = YES;
    
    _fakeImageView.image = nil;
    _fakeImageView.tintColor = nil;
    _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.iconSize = kDefaultIconSize;
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self setNeedsLayout];
}

- (UIImageView *)imageView {
    if (!_fakeImageView) {
        _fakeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _iconSize.width, _iconSize.height)];
        _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
        [super imageView].image = [UIImage rg_coloredImage:[UIColor clearColor] size:_iconSize];
        [self.contentView addSubview:_fakeImageView];
    }
    return _fakeImageView;
}

- (void)setIconResizeMode:(RGIconResizeMode)iconResizeMode {
    if (_iconResizeMode != iconResizeMode) {
        _iconResizeMode = iconResizeMode;
        [self setNeedsLayout];
    }
}

- (void)setIconCornerRound:(BOOL)iconCornerRound {
    if (iconCornerRound == _iconCornerRound) {
        return;
    }
    _iconCornerRound = iconCornerRound;
    [self setNeedsLayout];
}

- (void)setIconBackgroundColor:(UIColor *)iconBackgroundColor {
    _iconBackgroundColor = iconBackgroundColor;
    self.imageView.backgroundColor = iconBackgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubViewFrame];
    if (!_adjustIconBackgroundWhenHighlighted) {
        self.imageView.backgroundColor = _iconBackgroundColor;
    }
}

- (void)updateSubViewFrame {
    UIView *displayView = nil;
    if (self.imageView.isHidden || self.customIcon) {
        if ([self.customIcon isKindOfClass:UIView.class]) {
            ((UIView *)self.customIcon).frame = [super imageView].frame;
            self.imageView.frame = [super imageView].frame;
            displayView = self.customIcon;
        }
    } else {
        if (RGIconResizeModeNone != _iconResizeMode) {
            UIImage *icon = self.imageView.image;
            if ([self needResizeImage:icon]) {
                CGSize size = self->_iconSize;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    UIImage *subImage = [icon rg_resizeImageWithSize:size iconResizeMode:self->_iconResizeMode];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (icon == self.imageView.image) {
                            self.imageView.image = subImage;
                        }
                    });
                });
            }
        }
        self.imageView.frame = [super imageView].frame;
        displayView = self.imageView;
    }
    
    if (_iconCornerRound) {
        displayView.clipsToBounds = YES;
        displayView.layer.cornerRadius = CGRectGetHeight(displayView.frame)/2.0f;
    } else {
        displayView.clipsToBounds = NO;
        displayView.layer.cornerRadius = 0.0f;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!_adjustIconBackgroundWhenHighlighted) {
        self.imageView.backgroundColor = _iconBackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (!_adjustIconBackgroundWhenHighlighted) {
        self.imageView.backgroundColor = _iconBackgroundColor;
    }
}

#pragma mark - resize Image
- (BOOL)needResizeImage:(UIImage *)image {
    return (image.size.height > _iconSize.height || image.size.width > _iconSize.width);
}


@end
