//
//  RGLayout.h
//  RGUIKit
//
//  Created by renge on 2019/12/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RGLayout;

typedef RGLayout*_Nonnull(^RGLayoutFrame)(CGRect frame);
typedef RGLayout*_Nonnull(^RGLayoutSize)(CGSize size);
typedef RGLayout*_Nonnull(^RGLayoutValue)(CGFloat value);

@interface RGLayout : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, weak) UIView *view;

#pragma mark - config

@property (nonatomic, copy, readonly) RGLayout*(^target)(UIView *view);
@property (nonatomic, copy, readonly) RGLayout*(^inFrame)(CGRect inFrame);
@property (nonatomic, copy, readonly) RGLayout*(^targetNext)(UIView *view, CGRect inFrame);

@property (nonatomic, copy, readonly) RGLayoutFrame transBaseTo;
@property (nonatomic, copy, readonly) RGLayout*_Nonnull(^endTransBase)(void);

@property (nonatomic, copy, readonly) RGLayout*(^apply)(void);

#pragma mark - size

@property (nonatomic, copy, readonly) RGLayoutValue width;
@property (nonatomic, copy, readonly) RGLayoutValue height;
@property (nonatomic, copy, readonly) RGLayoutSize size;
@property (nonatomic, copy, readonly) RGLayout*(^sizeMake)(CGFloat width, CGFloat height);

@property (nonatomic, copy, readonly) RGLayoutSize sizeFits;
@property (nonatomic, copy, readonly) RGLayoutValue sizeFitsWidth;
@property (nonatomic, copy, readonly) RGLayout*(^sizeFitsInSize)(void(^inSize)(CGSize *inSize));

@property (nonatomic, copy, readonly) RGLayout*(^sizeInsets)(UIEdgeInsets insets);

@property (nonatomic, copy, readonly) RGLayout*(^sizeString)(NSString *string, CGFloat width, NSStringDrawingOptions options, NSDictionary<NSAttributedStringKey, id> * _Nullable attributes);
@property (nonatomic, copy, readonly) RGLayout*(^sizeFontString)(NSString *string, CGFloat width, UIFont *font);
@property (nonatomic, copy, readonly) RGLayout*(^sizeAttributedString)(NSAttributedString *string, CGFloat width);

#pragma mark - position

@property (nonatomic, copy, readonly) RGLayoutValue left;
@property (nonatomic, copy, readonly) RGLayoutValue top;
@property (nonatomic, copy, readonly) RGLayoutValue right;
@property (nonatomic, copy, readonly) RGLayoutValue bottom;
@property (nonatomic, copy, readonly) RGLayoutValue leading;
@property (nonatomic, copy, readonly) RGLayoutValue trailing;
@property (nonatomic, copy, readonly) RGLayout*(^center)(CGFloat x, CGFloat y);

@property (nonatomic, copy, readonly) RGLayoutValue centerX;
@property (nonatomic, copy, readonly) RGLayoutValue centerY;

@property (nonatomic, copy, readonly) RGLayoutFrame centerIn;
@property (nonatomic, copy, readonly) RGLayoutFrame centerXIn;
@property (nonatomic, copy, readonly) RGLayoutFrame centerYIn;

@property (nonatomic, copy, readonly) RGLayout*(^dx)(CGFloat x);
@property (nonatomic, copy, readonly) RGLayout*(^dy)(CGFloat y);

+ (RGLayout *)layoutWithView:(UIView * _Nullable)view inFrame:(CGRect)inFrame;
+ (RGLayout *)shared;
 
@end

NS_ASSUME_NONNULL_END
