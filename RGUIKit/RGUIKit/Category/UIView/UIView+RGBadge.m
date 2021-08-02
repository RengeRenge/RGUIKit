//
//  UIView+RGBadge.m
//  RGUIKit
//
//  Created by renge on 2021/8/2.
//

#import "UIView+RGBadge.h"
#import "UIImage+RGTint.h"
#import "UIView+RGLayoutHelp.h"

#import <RGObserver/RGObserver.h>
#import <RGRunTime/RGRunTime.h>

#define kUITabbarCustomNormalBadgeHeight 10
#define kUITabbarCustomWarningBadgeHeight 18

char *rg_badgeViewKey = "rg_badgeView";
char *rg_badgePositionKey = "rg_badgePosition";
char *rg_badgeHorizontalMarginKey = "rg_badgeHorizontalMargin";

@implementation UIView(RGBadge)

- (UIButton *)rg_badgeView {
    return [self rg_valueforConstKey:rg_badgeViewKey];
}

- (void)setRg_badgeView:(UIButton *)rg_badgeView {
    [self rg_setValue:rg_badgeView forConstKey:rg_badgeViewKey retain:YES];
}

- (UIButton *)createBadgeViewIfNeed {
    UIButton *badgeView = self.rg_badgeView;
    if (!badgeView) {
        badgeView = [[UIButton alloc] init];
        badgeView.userInteractionEnabled = NO;
        badgeView.layer.masksToBounds = YES;
        badgeView.tintColor = [UIColor redColor];
        badgeView.titleLabel.textAlignment = NSTextAlignmentCenter;
        badgeView.titleLabel.font = [UIFont systemFontOfSize:13];
        badgeView.adjustsImageWhenHighlighted = NO;
        badgeView.clipsToBounds = YES;
        self.rg_badgeView = badgeView;
    }
    return badgeView;
}

- (RGUIViewBadgePosition)rg_badgePosition {
    return [[self rg_valueforConstKey:rg_badgePositionKey] integerValue];
}

- (void)setRg_badgePosition:(RGUIViewBadgePosition)rg_badgePosition {
    [self rg_setValue:@(rg_badgePosition) forConstKey:rg_badgePositionKey retain:YES];
    [self __rg_addBadgeView:self.rg_badgeView];
}

- (CGFloat)rg_badgeHorizontalMargin {
    return [[self rg_valueforConstKey:rg_badgeHorizontalMarginKey] floatValue];
}

- (void)setRg_badgeHorizontalMargin:(CGFloat)rg_badgeHorizontalMargin {
    [self rg_setValue:@(rg_badgeHorizontalMargin) forConstKey:rg_badgeHorizontalMarginKey retain:YES];
    [self __rg_addBadgeView:self.rg_badgeView];
}

- (void)rg_showBadgeWithType:(RGUIViewBadgeType)type {
    switch (type) {
        case RGUIViewBadgeTypeNormal:
            break;
        case RGUIViewBadgeTypeValue:
            return;
        default:
            [self __rg_removeBadgeView];
            return;
    }
    
    CGFloat height = kUITabbarCustomNormalBadgeHeight;
    UIButton *badgeView = self.createBadgeViewIfNeed;
    badgeView.frame = CGRectMake(0, 0, height, height);
    badgeView.layer.cornerRadius = height / 2;
    
    [badgeView setTitle:nil forState:UIControlStateNormal];
    [badgeView setBackgroundImage:[UIImage rg_templateImageWithSize:CGSizeMake(2, 2)] forState:UIControlStateNormal];
    
    [self __rg_addBadgeView:badgeView];
}

- (void)rg_showBadgeWithValue:(NSString *)value {
    if (!value) {
        [self __rg_removeBadgeView];
        return;
    }
    
    CGFloat height = kUITabbarCustomWarningBadgeHeight;
    CGFloat width = kUITabbarCustomWarningBadgeHeight;
    UIButton *badgeView = self.createBadgeViewIfNeed;
    
    [badgeView setTitle:value forState:UIControlStateNormal];
    [badgeView setBackgroundImage:[UIImage rg_templateImageWithSize:CGSizeMake(2, 2)] forState:UIControlStateNormal];
    [badgeView sizeToFit];
    
    width = MAX(CGRectGetWidth(badgeView.frame) + 10, width);
    badgeView.frame = CGRectMake(0, 0, width, height);
    
    badgeView.layer.cornerRadius = height / 2;
    
    [self __rg_addBadgeView:badgeView];
}

- (void)__rg_addBadgeView:(UIButton *)badgeView {
    BOOL layoutLeftToRight = self.rg_layoutLeftToRight;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = badgeView.frame.size.width;
    CGFloat height = badgeView.frame.size.height;
    CGFloat margin = self.rg_badgeHorizontalMargin;
    RGUIViewBadgePosition position = self.rg_badgePosition;
    
    if (position & RGUIViewBadgeHorizontalTrailingOutFull) {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame);
        } else {
            x = - width;
        }
    } else if (position & RGUIViewBadgeHorizontalTrailingOutHalf) {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame) - width / 2.f;
        } else {
            x = - width / 2.f;
        }
    } else {
        if (layoutLeftToRight) {
            x = CGRectGetWidth(self.frame) - width;
        } else {
            x = 0;
        }
    }
    if (layoutLeftToRight) {
        x -= margin;
    } else {
        x += margin;
    }
    
    if (position & RGUIViewBadgeVerticalTopOutFull) {
        y = - height;
    } else if (position & RGUIViewBadgeVerticalTopOutHalf) {
        y = - height / 2.f;
    } else if (position & RGUIViewBadgeVerticalCenter) {
        y = (CGRectGetHeight(self.frame) - height) / 2.f;
    }

    badgeView.frame = CGRectMake(x, y, width, height);
    
    UIViewAutoresizing resize = UIViewAutoresizingFlexibleBottomMargin;
    if (position & RGUIViewBadgeVerticalCenter) {
        resize |= UIViewAutoresizingFlexibleBottomMargin;
    }
    if (layoutLeftToRight) {
        resize |= UIViewAutoresizingFlexibleLeftMargin;
    } else {
        resize |= UIViewAutoresizingFlexibleRightMargin;
    }
    
    badgeView.autoresizingMask = resize;
    if (badgeView.superview != self) {
        [self addSubview:badgeView];
    }
    
    [self rg_addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:rg_badgePositionKey];
    [self rg_addObserver:self forKeyPath:@"semanticContentAttribute" options:NSKeyValueObservingOptionNew context:rg_badgePositionKey];
}

- (void)__rg_removeBadgeView {
    [self rg_removeObserver:self forKeyPath:@"frame"];
    [self rg_removeObserver:self forKeyPath:@"semanticContentAttribute"];
    [self.rg_badgeView removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self &&
        context == rg_badgePositionKey &&
        ([keyPath isEqualToString:@"frame"] ||
         [keyPath isEqualToString:@"semanticContentAttribute"])
        ) {
        if (self.rg_badgeView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __rg_addBadgeView:self.rg_badgeView];
            });
        }
    }
}

@end
