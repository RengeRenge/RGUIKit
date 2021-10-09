//
//  UIView+RGBadge.h
//  RGUIKit
//
//  Created by renge on 2021/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RGUIViewBadgeType) {
    RGUIViewBadgeTypeNone,
    RGUIViewBadgeTypeNormal,
    RGUIViewBadgeTypeValue
};

typedef NS_ENUM(NSInteger, RGUIViewBadgePosition) {
    RGUIViewBadgeHorizontalTrailing = 0,
    RGUIViewBadgeHorizontalTrailingOutHalf = 1<<0,
    RGUIViewBadgeHorizontalTrailingOutFull = 1<<1,
    
    RGUIViewBadgeVerticalTop = 1<<2,
    RGUIViewBadgeVerticalTopOutHalf = 1<<3,
    RGUIViewBadgeVerticalTopOutFull = 1<<4,
    RGUIViewBadgeVerticalCenter = 1<<5
};

@interface UIView(RGBadge)

@property (nonatomic, strong, readonly) UIButton *rg_badgeView;

@property (nonatomic, assign) RGUIViewBadgePosition rg_badgePosition;
@property (nonatomic, assign) CGFloat rg_badgeHorizontalMargin;
@property (nonatomic, assign) CGFloat rg_badgeVerticalMargin;

- (void)rg_showBadgeWithType:(RGUIViewBadgeType)type;
- (void)rg_showBadgeWithValue:(NSString *__nullable)value;

@end

@interface UIBarButtonItem(RGBadge)

- (void)rg_getView:(void(^)(UIView *view))result;

@end

NS_ASSUME_NONNULL_END
