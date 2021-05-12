//
//  RGTableViewWrapperCell.h
//  RGUIKit
//
//  Created by renge on 2021/4/25.
//

#import <RGUIKit/RGUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RGTableViewWrapperSeparatorStyleNone,
    RGTableViewWrapperSeparatorStyleContentDefault,
    RGTableViewWrapperSeparatorStyleContentFull,
    RGTableViewWrapperSeparatorStyleWrapperFull,
} RGTableViewWrapperSeparatorStyle;

typedef enum : NSUInteger {
    RGTableViewWrapperSeparatorPositionBottom,
    RGTableViewWrapperSeparatorPositionTop,
    RGTableViewWrapperSeparatorPositionContentBottom,
    RGTableViewWrapperSeparatorPositionContentTop,
} RGTableViewWrapperSeparatorPosition;

typedef enum : NSUInteger {
    RGTableViewHighlightAreaNone,
    RGTableViewHighlightAreaContent,
    RGTableViewHighlightAreaFull,
} RGTableViewHighlightArea;

extern NSString * const RGTableViewWrapperCellID;

@class RGTableViewWrapperCell, RGTableViewWrapperCellRowAction, UITableViewRowAction;

@protocol RGTableViewWrapperCellDelegate <NSObject>

/// 在有内边距的 cell 上开启左滑功能
- (BOOL)tableView:(UITableView *)tableView wrapperCell:(RGTableViewWrapperCell *)cell  canEditRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray<RGTableViewWrapperCellRowAction *> *)tableView:(UITableView *)tableView wrapperCell:(RGTableViewWrapperCell *)cell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RGTableViewWrapperCell <__covariant RGContentCell> : RGTableViewCell

@property (nonatomic, strong, nullable) __kindof UITableViewCell *contentCell;

@property (nonatomic, assign) UIEdgeInsets edge;

@property (nonatomic, assign) RGTableViewWrapperSeparatorStyle customSeparatorStyle;
@property (nonatomic, assign) RGTableViewWrapperSeparatorPosition customSeparatorPosition;
@property (nonatomic, assign) UIEdgeInsets customSeparatorEdge; // 在 customSeparatorStyle 的基础上修正
@property (nonatomic, strong) UIView *customSeparatorView;

@property (nonatomic, strong) CALayer *shadowLayer; // default Hidden

@property (nonatomic, strong) CAShapeLayer *roundedLayer;
@property (nonatomic, assign) UIRectCorner contentCorner;
@property (nonatomic, assign) CGFloat contentCornerRadius;

@property (nonatomic, assign) RGTableViewHighlightArea highlightArea;

@property (nonatomic, weak) id <RGTableViewWrapperCellDelegate> delegate;

+ (UIColor *)separatorColor;

+ (instancetype)wrapperContentCell:(__kindof UITableViewCell *__nullable)contentCell;

- (instancetype)initWithContentCell:(__kindof UITableViewCell *__nullable)contentCell;
- (instancetype)initWithContentCell:(__kindof UITableViewCell *__nullable)contentCell reuseIdentifier:(nullable NSString *)reuseIdentifier;

- (RGContentCell)contentCell;

- (RGContentCell)contentCellWithClass:(Class)cellClass;
- (RGContentCell)contentCellWithClass:(Class)cellClass style:(UITableViewCellStyle)style;

- (RGContentCell)contentCellWithNib:(UINib *)nib;
- (RGContentCell)contentCellWithNib:(UINib *)nib reuseIdentifier:(NSString *)identifier;

+ (void)deselectConentCellForTableView:(UITableView *)tableView animated:(BOOL)animated;
+ (void)deselectConentCellForTableView:(UITableView *)tableView applyOther:(BOOL)applyOther animated:(BOOL)animated;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

@interface RGTableViewWrapperCellRowAction : NSObject

@property (nonatomic, copy, readonly) RGTableViewWrapperCellRowAction *(^title)(NSString *title);
@property (nonatomic, copy, readonly) RGTableViewWrapperCellRowAction *(^style)(UITableViewRowActionStyle style);
@property (nonatomic, copy, readonly) RGTableViewWrapperCellRowAction *(^handler)(void(^)(UITableViewRowAction *action, NSIndexPath *indexPath));

+ (instancetype)action;

- (RGTableViewWrapperCellRowAction * _Nonnull (^ _Nonnull)(void (^ _Nonnull)(UITableViewRowAction * _Nonnull, NSIndexPath * _Nonnull)))handler;

@end

NS_ASSUME_NONNULL_END
