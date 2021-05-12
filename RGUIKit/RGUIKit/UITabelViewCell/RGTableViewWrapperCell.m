//
//  RGTableViewWrapperCell.m
//  RGUIKit
//
//  Created by renge on 2021/4/25.
//

#import "RGTableViewWrapperCell.h"

NSString * const RGTableViewWrapperCellID = @"RGTableViewWrapperCellID";

@interface RGTableViewWrapperCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL highlightedEnable;
@property (nonatomic, assign) BOOL roundedChanged;
@property (nonatomic, strong) UITableView *tbWrapper;

@end

@interface RGTableViewWrapperCellRowAction ()

@property (nonatomic, assign) UITableViewRowActionStyle rStyle;
@property (nonatomic, copy) NSString *rTitle;
@property (nonatomic, copy) void (^rHandler)(UITableViewRowAction *action, NSIndexPath *indexPath);

@end

@implementation RGTableViewWrapperCell

@synthesize contentCell = _contentCell;

+ (instancetype)wrapperContentCell:(__kindof UITableViewCell *)contentCell {
    return [[self alloc] initWithContentCell:contentCell];
}

+ (instancetype)new {
    return [[self alloc] initWithContentCell:nil];
}

- (instancetype)initWithContentCell:(__kindof UITableViewCell *)contentCell {
    return [self initWithContentCell:contentCell reuseIdentifier:nil];
}

- (instancetype)initWithContentCell:(UITableViewCell *)contentCell reuseIdentifier:(NSString *)reuseIdentifier {
    if ([self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentCell = contentCell;
    }
    return self;
}

- (void)cellDidInit {
    [super cellDidInit];
    [self setHighlightArea:RGTableViewHighlightAreaNone];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.customSeparatorView];
    
    self.tbWrapper = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tbWrapper.backgroundColor = UIColor.clearColor;
    self.tbWrapper.scrollEnabled = NO;
    self.tbWrapper.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbWrapper.estimatedRowHeight = 0;
    self.tbWrapper.estimatedSectionFooterHeight = 0;
    self.tbWrapper.estimatedSectionHeaderHeight = 0;
    self.tbWrapper.contentInset = UIEdgeInsetsZero;
    self.tbWrapper.dataSource = self;
    self.tbWrapper.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.tbWrapper.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.contentView addSubview:self.tbWrapper];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tbWrapper setEditing:editing animated:animated];
}

+ (void)deselectConentCellForTableView:(UITableView *)tableView animated:(BOOL)animated {
    [self deselectConentCellForTableView:tableView applyOther:YES animated:animated];
}

+ (void)deselectConentCellForTableView:(UITableView *)tableView applyOther:(BOOL)applyOther animated:(BOOL)animated {
    [self deselectConentCellForTableView:tableView applyOther:applyOther ignoreCell:nil animated:animated];
}

+ (void)deselectConentCellForTableView:(UITableView *)tableView applyOther:(BOOL)applyOther ignoreCell:(RGTableViewWrapperCell *)ignoreCell animated:(BOOL)animated {
    [tableView.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:obj];
        if ([cell isKindOfClass:self.class]) {
            RGTableViewWrapperCell *wCell = (RGTableViewWrapperCell *)cell;
            if (wCell == ignoreCell) {
                return;
            }
            [wCell __select:NO animated:animated];
            [tableView deselectRowAtIndexPath:obj animated:animated];
        } else if (applyOther) {
            [tableView deselectRowAtIndexPath:obj animated:animated];
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edge = self.edge;
    
    CGRect oBounds = self.contentView.bounds;
    CGRect bounds = UIEdgeInsetsInsetRect(oBounds, edge);
    
    if (!CGRectEqualToRect(self.contentCell.frame, bounds)) {
        self.tbWrapper.frame = bounds;
        self.tbWrapper.rowHeight = bounds.size.height;
        self.tbWrapper.contentOffset = CGPointZero;
        if (!self.rg_layoutLeftToRight) {
            [self.tbWrapper rg_setFrameToFitRTL];
        }
        [self.tbWrapper layoutIfNeeded];
    }
    
    CGRect pathFrame = self.tbWrapper.frame;
    
    _roundedLayer = nil;
    CGPathRef roundedPathRef = [UIBezierPath bezierPathWithRoundedRect:pathFrame byRoundingCorners:_contentCorner cornerRadii:CGSizeMake(_contentCornerRadius, _contentCornerRadius)].CGPath;
    [self.roundedLayer setPath:roundedPathRef];
    self.contentView.layer.mask = self.roundedLayer;

    CGRect shadowFrame = [self.contentView convertRect:pathFrame toView:self];
    if (_roundedChanged || !CGRectEqualToRect(_shadowLayer.frame, shadowFrame)) {
        _shadowLayer.frame = shadowFrame;
        _shadowLayer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_shadowLayer.bounds byRoundingCorners:_contentCorner cornerRadii:CGSizeMake(_contentCornerRadius, _contentCornerRadius)].CGPath;
    }

    _roundedChanged = NO;

    /*------- separatorInset ------*/
    CGRect frame = CGRectZero;
    switch (_customSeparatorStyle) {
        case RGTableViewWrapperSeparatorStyleNone:
            frame = CGRectZero;
            break;
        case RGTableViewWrapperSeparatorStyleContentDefault:
            frame = UIEdgeInsetsInsetRect(bounds,
                                          UIEdgeInsetsMake(
                                                           CGRectGetHeight(bounds) - 0.5,
                                                           self.contentCell.separatorInset.left,
                                                           0,
                                                           self.contentCell.separatorInset.right
                                                           )
                                          );
            break;
        case RGTableViewWrapperSeparatorStyleContentFull:
            frame = CGRectMake(bounds.origin.x, 0, bounds.size.width, 0.5);
            break;
        case RGTableViewWrapperSeparatorStyleWrapperFull:
            frame = CGRectMake(oBounds.origin.x, 0, self.bounds.size.width, 0.5);
            break;
        default:
            break;
    }
    
    switch (_customSeparatorPosition) {
        case RGTableViewWrapperSeparatorPositionBottom:
            frame.origin.y = CGRectGetMaxY(oBounds) - CGRectGetHeight(frame);
            break;
        case RGTableViewWrapperSeparatorPositionTop:
            frame.origin.y = 0;
            break;
        case RGTableViewWrapperSeparatorPositionContentBottom:
            frame.origin.y = CGRectGetMaxY(bounds) - CGRectGetHeight(frame);
            break;
        case RGTableViewWrapperSeparatorPositionContentTop:
            frame.origin.y = CGRectGetMinY(bounds);
            break;
        default:
            break;
    }
    
    frame = UIEdgeInsetsInsetRect(frame, _customSeparatorEdge);
    _customSeparatorView.frame = frame;
    _customSeparatorView.hidden = RGTableViewWrapperSeparatorStyleNone == _customSeparatorStyle;
    [self bringSubviewToFront:_customSeparatorView];

    if (!self.rg_layoutLeftToRight) {
        [_customSeparatorView rg_setFrameToFitRTL];
    }
    [super subViewsDidLayoutForClass:RGTableViewWrapperCell.class];
}

- (void)dealloc {
    
}

#pragma mark - Overwrite

- (UILabel *)detailTextLabel {
    return self.contentCell.detailTextLabel;
}

- (UILabel *)textLabel {
    return self.contentCell.textLabel;
}

- (UIImageView *)imageView {
    return self.contentCell.imageView;
}

#pragma mark - Get/Set

+ (UIColor *)separatorColor {
    return [UIColor rg_colorWithDynamicProvider:^UIColor * _Nonnull(BOOL dark) {
        return dark ?
        [UIColor colorWithRed:0.33 green:0.33 blue:0.35 alpha:0.6]
        :
        [UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.29];
    }];
}

- (void)setContentCell:(UITableViewCell *)contentCell {
    if (_contentCell == contentCell) {
        return;
    }
    _contentCell = contentCell;
    [self.tbWrapper reloadData];
}

- (RGTableViewCell *)contentCell {
    if (!_contentCell) {
        _contentCell = [[RGTableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:nil];
        [self.tbWrapper reloadData];
    }
    return _contentCell;
}

- (id)contentCellWithClass:(Class)cellClass {
    return [self contentCellWithClass:cellClass style:self.cellStyle];
}

- (id)contentCellWithClass:(Class)cellClass style:(UITableViewCellStyle)style {
    if ([_contentCell isMemberOfClass:cellClass]) {
        if ([_contentCell isKindOfClass:RGTableViewCell.class]) {
            if ([(RGTableViewCell *)_contentCell cellStyle] == style) {
                return _contentCell;
            }
        } else {
            return _contentCell;
        }
    }
    _contentCell = [[cellClass alloc] initWithStyle:style reuseIdentifier:nil];
    self.highlightArea = self.highlightArea;
    [self.tbWrapper reloadData];
    return _contentCell;
}

- (id)contentCellWithNib:(UINib *)nib {
    NSString *identifier = NSStringFromClass(self.class);
    return [self contentCellWithNib:nib reuseIdentifier:identifier];
}

- (id)contentCellWithNib:(UINib *)nib reuseIdentifier:(nonnull NSString *)identifier {
    [self.tbWrapper registerNib:nib forCellReuseIdentifier:identifier];
    _contentCell = [self.tbWrapper dequeueReusableCellWithIdentifier:identifier];
    self.highlightArea = self.highlightArea;
    [self.tbWrapper reloadData];
    return _contentCell;
}

- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer layer];
        _shadowLayer.shadowOffset = CGSizeMake(0, 0);
        _shadowLayer.shadowRadius = 4.0;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.12;
        _shadowLayer.hidden = YES;
        [self.layer insertSublayer:_shadowLayer atIndex:0];
        [self setNeedsLayout];
    }
    return _shadowLayer;
}

- (CAShapeLayer *)roundedLayer {
    if (!_roundedLayer) {
        _roundedLayer = [[CAShapeLayer alloc] init];
        _roundedLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    return _roundedLayer;
}

- (UIView *)customSeparatorView {
    if (!_customSeparatorView) {
        _customSeparatorView = [[UIView alloc] init];
        _customSeparatorView.backgroundColor = self.class.separatorColor;
    }
    return _customSeparatorView;
}

- (void)setEdge:(UIEdgeInsets)edge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_edge, edge)) {
        _edge = edge;
        [self setNeedsLayout];
    }
}

- (void)setCustomSeparatorEdge:(UIEdgeInsets)customSeparatorEdge {
    if (!UIEdgeInsetsEqualToEdgeInsets(_customSeparatorEdge, customSeparatorEdge)) {
        _customSeparatorEdge = customSeparatorEdge;
        [self setNeedsLayout];
    }
}

- (void)setContentCorner:(UIRectCorner)contentCorner {
    _contentCorner = contentCorner;
    _roundedChanged = YES;
    [self setNeedsLayout];
}

- (void)setContentCornerRadius:(CGFloat)contentCornerRadius {
    _contentCornerRadius = contentCornerRadius;
    _roundedChanged = YES;
    [self setNeedsLayout];
}

- (void)setCustomSeparatorStyle:(RGTableViewWrapperSeparatorStyle)customSeparatorStyle {
    if (customSeparatorStyle != _customSeparatorStyle) {
        _customSeparatorStyle = customSeparatorStyle;
        [self setNeedsLayout];
    }
}

#pragma mark - Select/Highlight

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    NSLog(@"[%@] selected:%d animated:%d", self.contentCell.textLabel.text, selected, animated);
    if (_highlightedEnable) {
        [self __select:selected animated:animated];
//        [self.contentCell setSelected:selected animated:animated];
        
        void(^config)(BOOL state) = ^(BOOL state) {
            self->_customSeparatorView.alpha = (state || self.highlighted) ? 0 : 1.f;
        };
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                config(selected);
            }];
        } else {
            config(selected);
        }
    }
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    NSLog(@"[%@] highlighted:%d animated:%d", self.contentCell.textLabel.text, highlighted, animated);
    if (_highlightedEnable) {
        [self.contentCell setHighlighted:highlighted animated:animated];
        
        void(^config)(BOOL state) = ^(BOOL state) {
            self->_customSeparatorView.alpha = (state || self.selected) ? 0 : 1.f;
        };
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                config(highlighted);
            }];
        } else {
            config(highlighted);
        }
    }
    [super setHighlighted:highlighted animated:animated];
}

- (void)setHighlightArea:(RGTableViewHighlightArea)highlightArea {
    _highlightArea = highlightArea;
    switch (highlightArea) {
        case RGTableViewHighlightAreaNone:
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.highlightedEnable = NO;
            break;
        case RGTableViewHighlightAreaContent:
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.highlightedEnable = YES;
            break;
        case RGTableViewHighlightAreaFull:
            self.highlightedEnable = YES;
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.contentCell.contentView.backgroundColor = UIColor.clearColor;
            self.contentCell.backgroundColor = UIColor.clearColor;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.highlightArea = self.highlightArea;
    return self.contentCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentCell ? 1 : 0;
}

#pragma mark - UITableViewDelegate

/*
 
 [UITableview normal step]
 1: self    highlighted :1      animated:0
 2: self    highlighted :0      animated:0
 3: other   selected    :0      animated:0
 4: self    selected    :1      animated:0
 
 */

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selected) {
        return nil;
    }
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    
//    if (!tb.allowsMultipleSelection) {
//        [self.class deselectConentCellForTableView:tb applyOther:YES ignoreCell:self animated:NO];
//    }
    
    if ([tb.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        if (![[tb.delegate tableView:tb willSelectRowAtIndexPath:selfPath] isEqual:selfPath]) {
            return nil;
        }
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    
    [tb selectRowAtIndexPath:selfPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    if ([tb.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [tb.delegate tableView:tb didSelectRowAtIndexPath:selfPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    
    [tb deselectRowAtIndexPath:selfPath animated:NO];
    
    if ([tb.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [tb.delegate tableView:tb didDeselectRowAtIndexPath:selfPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    if ([tb.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        if (![tb.delegate tableView:tb shouldHighlightRowAtIndexPath:selfPath]) {
            return NO;
        }
    }
    [self setHighlighted:YES animated:NO];
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setHighlighted:NO animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.delegate respondsToSelector:@selector(tableView:wrapperCell:canEditRowAtIndexPath:)]) {
        return NO;
    }
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    return [self.delegate tableView:tb wrapperCell:self canEditRowAtIndexPath:selfPath];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tb = self.__tb;
    [tb setEditing:NO animated:YES];
    [[tb visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:self.class] && obj != self) {
            RGTableViewWrapperCell *cell = (RGTableViewWrapperCell *)obj;
            [cell.tbWrapper setEditing:NO animated:YES];
        }
    }];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.delegate respondsToSelector:@selector(tableView:wrapperCell:editActionsForRowAtIndexPath:)]) {
        return nil;
    }
    UITableView *tb = self.__tb;
    NSIndexPath *selfPath = [tb indexPathForCell:self];
    NSArray <RGTableViewWrapperCellRowAction *> *array = [self.delegate tableView:tb wrapperCell:self editActionsForRowAtIndexPath:selfPath];
    NSMutableArray <UITableViewRowAction *> *actions = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(RGTableViewWrapperCellRowAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        void(^handler)(UITableViewRowAction *action, NSIndexPath *indexPath) = obj.rHandler;
        UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:obj.rStyle title:obj.rTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull myIndexPath) {
            if (handler) {
                handler(action, selfPath);
            }
        }];
        [actions addObject:action];
    }];
    return actions;
}

- (UITableView *)__tb {
    UIView *t = self.superview;
    while (t && ![t isKindOfClass:UITableView.class]) {
        t = t.superview;
    }
    return (UITableView *)t;
}

- (void)__select:(BOOL)select animated:(BOOL)animated {
    [self.tbWrapper.indexPathsForVisibleRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (select) {
            [self.tbWrapper selectRowAtIndexPath:obj animated:animated scrollPosition:UITableViewScrollPositionNone];
        } else {
            [self.tbWrapper deselectRowAtIndexPath:obj animated:animated];
        }
    }];
}

- (void)__subCellSelect:(BOOL)select animated:(BOOL)animated {
    [self.tbWrapper.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelected:select animated:animated];
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    switch (self.highlightArea) {
        case RGTableViewHighlightAreaContent: {
            if (CGRectContainsPoint(_tbWrapper.frame, point)) {
                return [super hitTest:point withEvent:event];
            }
            return nil;
        }
        default:
            return [super hitTest:point withEvent:event];
    }
}

@end

@implementation RGTableViewWrapperCellRowAction

+ (instancetype)action {
    return [[self.class alloc] init];
}

- (RGTableViewWrapperCellRowAction * _Nonnull (^)(UITableViewRowActionStyle))style {
    return ^(UITableViewRowActionStyle style) {
        self.rStyle = style;
        return self;
    };
}

- (RGTableViewWrapperCellRowAction * _Nonnull (^)(NSString * _Nonnull))title {
    return ^(NSString *title) {
        self.rTitle = title;
        return self;
    };
}

- (RGTableViewWrapperCellRowAction * _Nonnull (^)(void (^ _Nonnull)(UITableViewRowAction * _Nonnull, NSIndexPath * _Nonnull)))handler {
    return ^(void (^handler)(UITableViewRowAction * _Nonnull, NSIndexPath * _Nonnull)) {
        self.rHandler = handler;
        return self;
    };
}

@end
