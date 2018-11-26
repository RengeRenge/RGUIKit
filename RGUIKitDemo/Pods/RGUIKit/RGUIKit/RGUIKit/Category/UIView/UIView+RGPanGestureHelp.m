//
//  UIView+PanGestureHelp.m
//  CampTalk
//
//  Created by renge on 2018/4/28.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import "UIView+RGPanGestureHelp.h"
#import <objc/runtime.h>

char *rg_kOriginCenter = "rg_kOriginCenter";
char *rg_kStartPoint = "rg_kStartPoint";
char *rg_kOriginSize = "rg_kOriginSize";

@implementation UIView (RGPanGestureHelp)

- (void)setRg_originCenter:(CGPoint)rg_originCenter {
    objc_setAssociatedObject(self, rg_kOriginCenter, [NSNumber valueWithCGPoint:rg_originCenter], OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_originCenter {
    return [objc_getAssociatedObject(self, rg_kOriginCenter) CGPointValue];
}

- (void)setRg_originSize:(CGSize)rg_originSize {
    objc_setAssociatedObject(self, rg_kOriginSize, [NSNumber valueWithCGSize:rg_originSize], OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)rg_originSize {
    return [objc_getAssociatedObject(self, rg_kOriginSize) CGSizeValue];
}

- (void)setRg_startPoint:(CGPoint)rg_startPoint {
    objc_setAssociatedObject(self, rg_kStartPoint, [NSNumber valueWithCGPoint:rg_startPoint], OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_startPoint {
    return [objc_getAssociatedObject(self, rg_kStartPoint) CGPointValue];
}

- (void)rg_startWithPoint:(CGPoint)startPoint {
    self.rg_originCenter = self.center;
    self.rg_startPoint = startPoint;
}

- (void)rg_updateCenterWithNewPoint:(CGPoint)newPoint {
    CGPoint startPoint = self.rg_startPoint;
    CGFloat deltaX = newPoint.x - startPoint.x;
    CGFloat deltaY = newPoint.y - startPoint.y;
    self.center = CGPointMake(self.rg_originCenter.x + deltaX, self.rg_originCenter.y + deltaY);
}

- (void)rg_centerScale:(CGFloat)scale {
    CGSize size = self.frame.size;
    
    CGRect frame = self.frame;
    
    CGFloat temp = size.height * scale;
    frame.origin.y -=  (temp - size.height) / 2.f;
    frame.size.height = temp;
    
    temp = size.width * scale;
    frame.origin.x -= (temp - size.width) / 2.f;
    frame.size.width = temp;
    self.frame = frame;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
