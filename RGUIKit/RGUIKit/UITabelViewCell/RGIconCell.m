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
#import <RGObserver/RGObserver.h>

#define textLabelFont       [UIFont systemFontOfSize:16.0f]
#define detailTextLabelFont [UIFont systemFontOfSize:12.0f];
#define accessoryButtonFont [UIFont systemFontOfSize:15.0f];

#define kDefaultIconSize CGSizeMake(RGTableViewCellDefaultIconDimension, RGTableViewCellDefaultIconDimension)

@interface RGIconCell () {
    UIImageView *_fakeImageView;
    UIRectCorner _corner;
    CGFloat _cornerRadius;
}

@property (nonatomic, strong, readonly) CAShapeLayer *cornerLayer;

@end

@implementation RGIconCell

@synthesize cornerLayer = _cornerLayer;

+ (RGIconCell *)getCell:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    RGIconCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.imageView rg_addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:@"RGIconCell"];
        [self resetConfig];
    }
    return self;
}

- (instancetype)initWithCustomStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithCustomStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.imageView rg_addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:@"RGIconCell"];
        [self resetConfig];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id myContext = (__bridge NSString * _Nonnull)(context);
    if ([keyPath isEqualToString:@"image"] && object == self.imageView && context && [myContext isKindOfClass:NSString.class] && [@"RGIconCell" isEqualToString:myContext]) {
        [self updateSubViewFrame];
    }
}

- (CAShapeLayer *)cornerLayer {
    if (!_cornerLayer) {
        _cornerLayer = [CAShapeLayer new];
        _cornerLayer.rasterizationScale = UIScreen.mainScreen.scale;
        _cornerLayer.shouldRasterize = YES;
    }
    return _cornerLayer;
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
        [self setIconCorner:_corner cornerRadius:_cornerRadius];
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

- (void)setIconCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius {
    
    if ((corner & UIRectCornerTopLeft ||
        corner & UIRectCornerTopRight ||
        corner & UIRectCornerBottomLeft ||
        corner & UIRectCornerBottomRight ||
        corner & UIRectCornerAllCorners) &&
        cornerRadius > 0) {
        
        if (corner != _corner || fabs(_cornerRadius - cornerRadius) > 1e-7) {
            
            _corner = corner;
            _cornerRadius = cornerRadius;
            
            CGRect bounds;
            bounds.size = self.iconSize;
            bounds.origin = CGPointZero;
            
            UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectIntegral(bounds) byRoundingCorners:_corner cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
            _cornerLayer.path = rounded.CGPath;
        }
        
        UIView *view = (_customIcon ? _customIcon : self.imageView);
        view.layer.mask = _cornerLayer;
    } else {
        UIView *view = (_customIcon ? _customIcon : self.imageView);
        view.layer.mask = nil;
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
        [self setIconCorner:_corner cornerRadius:_cornerRadius];
    }
}

- (void)resetConfig {
    _iconResizeMode = RGIconResizeModeScaleAspectFill;
    
    _fakeImageView.image = nil;
    _fakeImageView.tintColor = nil;
    _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.iconSize = kDefaultIconSize;
    [self cornerLayer];
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self setNeedsLayout];
}

- (UIImageView *)imageView {
    if (!_fakeImageView) {
        _fakeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _iconSize.width, _iconSize.height)];
        _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _fakeImageView.clipsToBounds = YES;
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
    [super subViewsDidLayoutForClass:RGIconCell.class];
}

- (void)updateSubViewFrame {
    if (self.imageView.isHidden || self.customIcon) {
        if ([self.customIcon isKindOfClass:UIView.class]) {
            ((UIView *)self.customIcon).frame = [super imageView].frame;
            self.imageView.frame = [super imageView].frame;
        }
    } else {
        if (RGIconResizeModeNone != _iconResizeMode) {
            UIImage *icon = self.imageView.image;
            if ([self needResizeImage:icon]) {
                CGSize size = self->_iconSize;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    UIImage *subImage = [icon rg_resizeImageWithSize:size iconResizeMode:self->_iconResizeMode];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (icon == self.imageView.image) {
                            self.imageView.image = subImage;
                        }
                    });
                });
            }
        }
        self.imageView.frame = [super imageView].frame;
    }
    
    [super subViewsDidLayoutForClass:RGIconCell.class];
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
