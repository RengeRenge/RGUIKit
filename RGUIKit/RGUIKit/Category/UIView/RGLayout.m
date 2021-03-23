//
//  RGLayout.m
//  RGUIKit
//
//  Created by renge on 2019/12/23.
//

#import "RGLayout.h"
#import "UIView+RGLayoutHelp.h"

@interface RGLayout ()

@property (nonatomic, assign) BOOL inMode;
@property (nonatomic, assign) CGRect rInFrame;
@property (nonatomic, assign) CGRect inBounds;

@end

@implementation RGLayout

#pragma mark - Init

+ (RGLayout *)shared {
    static RGLayout *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [RGLayout layoutWithView:nil inFrame:CGRectZero];
    });
    return shared;
}

+ (RGLayout *)layoutWithView:(UIView *)view inFrame:(CGRect)inFrame {
    RGLayout *layout = [[RGLayout alloc] initWithView:view inFrame:inFrame];
    return layout;
}

- (instancetype)initWithView:(UIView *)view inFrame:(CGRect)inFrame {
    if (self = [super init]) {
        self.view = view;
        self.inBounds = inFrame;
    }
    return self;
}

- (void)setView:(UIView *)view {
    _view = view;
    self.frame = view.frame;
}

- (CGRect)inBounds {
    if (self.inMode) {
        return self.rInFrame;
    } else {
        return _inBounds;
    }
}

#pragma mark - config

- (RGLayout * _Nonnull (^)(UIView * _Nonnull))target {
    return ^RGLayout *(UIView *view) {
        self.view = view;
        return self;
    };
}

- (RGLayout * _Nonnull (^)(CGRect))inFrame {
    return ^RGLayout *(CGRect frame) {
        self.inBounds = frame;
        self.inMode = NO;
        return self;
    };
}

- (RGLayout * _Nonnull (^)(UIView * _Nonnull, CGRect frame))targetNext {
    return ^RGLayout *(UIView *view, CGRect frame) {
        self.view = view;
        self.inBounds = frame;
        self.inMode = NO;
        return self;
    };
}

- (RGLayoutFrame)transBaseTo {
    return [self __frameParam:^(CGRect frame) {
        self.rInFrame = frame;
        self.inMode = YES;
    }];
}

- (RGLayout * _Nonnull (^)(void))endTransBase {
    return ^RGLayout * {
        self.rInFrame = CGRectZero;
        self.inMode = NO;
        return self;
    };
}

- (RGLayout*(^)(void))apply {
    return ^RGLayout*(void) {
        CGRect frame = self.frame;
        self.view.frame = RG_CGRectFlat(frame);
        return self;
    };
}

#pragma mark - size

- (RGLayoutValue)width {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.size.width = value;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)height {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.size.height = value;
        self.frame = mframe;
    }];
}

- (RGLayoutSize)size {
    return [self __sizeParam:^(CGSize size) {
        CGRect mframe = self.frame;
        mframe.size = size;
        self.frame = mframe;
    }];
}

- (RGLayout * _Nonnull (^)(CGFloat, CGFloat))sizeMake {
    return ^RGLayout * (CGFloat width, CGFloat height) {
        CGRect mframe = self.frame;
        mframe.size.width = width;
        mframe.size.height = height;
        self.frame = mframe;
        return self;
    };
}

- (RGLayoutSize)sizeFits {
    return [self __sizeParam:^(CGSize size) {
        CGRect mframe = self.frame;
        mframe.size = [self.view sizeThatFits:size];
        self.frame = mframe;
    }];
}

- (RGLayoutValue)sizeFitsWidth {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.size = [self.view sizeThatFits:CGSizeMake(value, CGFLOAT_MAX)];
        self.frame = mframe;
    }];
}

- (RGLayout * _Nonnull (^)(void (^ _Nonnull)(CGSize * _Nonnull)))sizeFitsInSize {
    return ^RGLayout * (void(^inSize)(CGSize *inSize)) {
        CGRect mframe = self.frame;
        
        CGSize size = mframe.size;
        inSize(&size);
        
        mframe.size = size;
        self.frame = mframe;
        return self;
    };
}

- (RGLayout * _Nonnull (^)(UIEdgeInsets))sizeInsets {
    return ^RGLayout * (UIEdgeInsets insets) {
        self.frame = UIEdgeInsetsInsetRect(self.frame, insets);
        return self;
    };
}

- (RGLayout * _Nonnull (^)(NSString * _Nonnull, CGFloat, NSStringDrawingOptions, NSDictionary<NSAttributedStringKey,id> * _Nullable))sizeString {
    return ^RGLayout * (NSString *string, CGFloat width, NSStringDrawingOptions options, NSDictionary<NSAttributedStringKey, id> * _Nullable attributes) {
        CGRect mframe = self.frame;
        mframe.size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
        self.frame = mframe;
        return self;
    };
}

- (RGLayout * _Nonnull (^)(NSString * _Nonnull, CGFloat, UIFont * _Nonnull))sizeFontString {
    return ^RGLayout * (NSString *string, CGFloat width, UIFont *font) {
        CGRect mframe = self.frame;
        mframe.size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
                                        attributes:@{NSFontAttributeName: font}
                                           context:nil].size;
        self.frame = mframe;
        return self;
    };
}

- (RGLayout * _Nonnull (^)(NSAttributedString * _Nonnull, CGFloat))sizeAttributedString {
    return ^RGLayout * (NSAttributedString *string, CGFloat width) {
        CGRect mframe = self.frame;
        mframe.size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
                                           context:nil].size;
        self.frame = mframe;
        return self;
    };
}

#pragma mark - position

- (RGLayoutValue)left {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.x = value + self.inBounds.origin.x;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)top {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.y = value + self.inBounds.origin.y;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)right {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.x = CGRectGetMaxX(self.inBounds) - value - mframe.size.width;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)bottom {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.y = CGRectGetMaxY(self.inBounds) - value - mframe.size.height;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)leading {
    if (self.view.rg_layoutLeftToRight) {
        return self.left;
    }
    return self.right;
}

- (RGLayoutValue)trailing {
    if (self.view.rg_layoutLeftToRight) {
        return self.right;
    }
    return self.left;
}

- (RGLayout * _Nonnull (^)(CGFloat, CGFloat))center {
    return ^RGLayout * (CGFloat x, CGFloat y) {
        CGRect mframe = self.frame;
        CGRect bounds = self.inBounds;
        mframe.origin.x = CGRectGetMinX(bounds) + x - mframe.size.width/2.f;
        mframe.origin.y = CGRectGetMinY(bounds) + y - mframe.size.height/2.f;
        self.frame = mframe;
        return self;
    };
}

- (RGLayoutValue)centerX {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.x = CGRectGetMinX(self.inBounds) + value - mframe.size.width/2.f;
        self.frame = mframe;
    }];
}

- (RGLayoutValue)centerY {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.y = CGRectGetMinY(self.inBounds) + value - mframe.size.height/2.f;
        self.frame = mframe;
    }];
}

- (RGLayoutFrame)centerIn {
    return [self __frameParam:^(CGRect frame) {
        CGRect mframe = self.frame;
        CGRect bounds = self.inBounds;
        mframe.origin.x = CGRectGetMinX(bounds) + CGRectGetMidX(frame) - mframe.size.width / 2.f;
        mframe.origin.y = CGRectGetMinY(bounds) + CGRectGetMidY(frame) - mframe.size.height / 2.f;
        self.frame = mframe;
    }];
}

- (RGLayoutFrame)centerXIn {
    return [self __frameParam:^(CGRect frame) {
        CGRect mframe = self.frame;
        mframe.origin.x = CGRectGetMinX(self.inBounds) + CGRectGetMidX(frame) - mframe.size.width / 2.f;
        self.frame = mframe;
    }];
}

- (RGLayoutFrame)centerYIn {
    return [self __frameParam:^(CGRect frame) {
        CGRect mframe = self.frame;
        mframe.origin.y = CGRectGetMinY(self.inBounds) + CGRectGetMidY(frame) - mframe.size.height / 2.f;
        self.frame = mframe;
    }];
}

- (RGLayout * _Nonnull (^)(CGFloat))dx {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        if (self.view.rg_layoutLeftToRight) {
            mframe.origin.x += value;
        } else {
            mframe.origin.x -= value;
        }
        self.frame = mframe;
    }];
}

- (RGLayout * _Nonnull (^)(CGFloat))dy {
    return [self __valueParam:^(CGFloat value) {
        CGRect mframe = self.frame;
        mframe.origin.y += value;
        self.frame = mframe;
    }];
}

#pragma mark - param

- (RGLayoutFrame)__frameParam:(void(^)(CGRect frame))param {
    RGLayoutFrame value = ^(CGRect frame) {
        param(frame);
        return self;
    };
    return value;
}

- (RGLayoutSize)__sizeParam:(void(^)(CGSize size))param {
    RGLayoutSize value = ^(CGSize size) {
        param(size);
        return self;
    };
    return value;
}

- (RGLayoutValue)__valueParam:(void(^)(CGFloat value))param {
    RGLayoutValue value = ^(CGFloat value) {
        param(value);
        return self;
    };
    return value;
}

@end

