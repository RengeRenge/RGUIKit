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

@property (nonatomic, strong) UIImage *oImage;
@property (nonatomic, strong) UIImage *rImage;
@property (nonatomic, strong) UIImage *resizingImage;

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

- (void)cellDidInit {
    [super cellDidInit];
    if (!self._hasImageView) {
        return;
    }
    [self cornerLayer];
    [self resetConfig];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id myContext = (__bridge NSString * _Nonnull)(context);
    if ([keyPath isEqualToString:@"image"] && object == _fakeImageView && context && [myContext isKindOfClass:NSString.class] && [@"RGIconCell" isEqualToString:myContext]) {
        [self __resizeCurrentImageIfNeed];
    }
}

- (CAShapeLayer *)cornerLayer {
    if (!self._hasImageView) {
        return nil;
    }
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
            _fakeImageView.hidden = YES;
            [self.contentView addSubview:_customIcon];
            [self setNeedsLayout];
        } else {
            _fakeImageView.hidden = NO;
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
        
        UIView *view = (_customIcon ? _customIcon : _fakeImageView);
        view.layer.mask = _cornerLayer;
    } else {
        UIView *view = (_customIcon ? _customIcon : _fakeImageView);
        view.layer.mask = nil;
    }
}

- (BOOL)_hasImageView {
    return [super imageView] != nil;
}

- (void)setIconSize:(CGSize)iconSize {
    _iconSize = iconSize;
    if (!self._hasImageView) {
        return;
    }
    
    CGRect frame = _fakeImageView.frame;
    frame.size = iconSize;
    _fakeImageView.frame = frame;
    
    if (!CGSizeEqualToSize(_iconSize, [super imageView].image.size)) {
        [super imageView].contentMode = UIViewContentModeCenter;
        [super imageView].image = [UIImage rg_coloredImage:[UIColor clearColor] size:_iconSize];
        [self setIconCorner:_corner cornerRadius:_cornerRadius];
        
        _rImage = nil;
        [self setNeedsLayout];
    }
}

- (void)resetConfig {
    _iconResizeMode = RGIconResizeModeScaleAspectFill;
    _fakeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconSize = kDefaultIconSize;
}

- (UIImageView *)imageView {
    if (self._hasImageView && !_fakeImageView && !CGSizeEqualToSize(self.iconSize, CGSizeZero)) {
        _fakeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _iconSize.width, _iconSize.height)];
        [_fakeImageView rg_addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:@"RGIconCell"];
        
        _fakeImageView.clipsToBounds = YES;
        [super imageView].image = [UIImage rg_coloredImage:[UIColor clearColor] size:_iconSize];
        [self.contentView addSubview:_fakeImageView];
    }
    return _fakeImageView;
}

- (void)setIconResizeMode:(RGIconResizeMode)iconResizeMode {
    if (_iconResizeMode != iconResizeMode) {
        _rImage = nil;
        _iconResizeMode = iconResizeMode;
        [self setNeedsLayout];
    }
}

- (void)setIconBackgroundColor:(UIColor *)iconBackgroundColor {
    _iconBackgroundColor = iconBackgroundColor;
    _fakeImageView.backgroundColor = iconBackgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubViewFrame];
    [self __resizeCurrentImageIfNeed];
    
    if (!_adjustIconBackgroundWhenHighlighted) {
        _fakeImageView.backgroundColor = _iconBackgroundColor;
    }
    [super subViewsDidLayoutForClass:RGIconCell.class];
}

- (void)updateSubViewFrame {
    _fakeImageView.frame = [super imageView].frame;
    if (_fakeImageView.isHidden || self.customIcon) {
        if ([self.customIcon isKindOfClass:UIView.class]) {
            ((UIView *)self.customIcon).frame = [super imageView].frame;
        }
    }
}

- (void)__resizeCurrentImageIfNeed {
    if (RGIconResizeModeNone != _iconResizeMode) {
        UIImage *icon = _fakeImageView.image;
        if ([_oImage isEqual:icon]) {
            if (_rImage) {
                _fakeImageView.image = _rImage;
                return;
            }
        }
        
        if ([_resizingImage isEqual:icon]) {
            return;
        }
        
        if ([self needResizeImage:icon]) {
            
            self.resizingImage = icon;
            CGSize size = self.iconSize;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *subImage = [icon rg_resizeImageWithSize:size iconResizeMode:self->_iconResizeMode];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_resizingImage = nil;
                    if (![icon isEqual:self->_fakeImageView.image] || !CGSizeEqualToSize(size, self->_iconSize)) {
                        return;
                    }
                    [self __recordImage:icon subImage:subImage];
                    self->_fakeImageView.image = subImage;
                });
            });
        }
    }
}

- (void)__recordImage:(UIImage *)image subImage:(UIImage *)subImage {
    _oImage = image;
    _rImage = subImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (!_adjustIconBackgroundWhenHighlighted) {
        _fakeImageView.backgroundColor = _iconBackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (!_adjustIconBackgroundWhenHighlighted) {
        _fakeImageView.backgroundColor = _iconBackgroundColor;
    }
}

#pragma mark - resize Image

- (BOOL)needResizeImage:(UIImage *)image {
    return (image.size.height > _iconSize.height || image.size.width > _iconSize.width);
}

@end
