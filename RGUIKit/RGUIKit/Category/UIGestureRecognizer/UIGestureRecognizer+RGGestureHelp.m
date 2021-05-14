//
//  UIGestureRecognizer+RGGestureHelp.m
//  CampTalk
//
//  Created by renge on 2018/4/28.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import "UIGestureRecognizer+RGGestureHelp.h"
#import <objc/runtime.h>
#import "UIView+RGLayoutHelp.h"

char *rg_kOriginCenter = "rg_kOriginCenter";
char *rg_kOriginPoint = "rg_kOriginPoint";
char *rg_kOriginPoints = "rg_kOriginPoints";
char *rg_kOriginSize = "rg_kOriginSize";
char *rg_kScale = "rg_kScale";
char *rg_kScaleCenter = "rg_kScaleCenter";
char *rg_kCurrentCenter = "rg_kCurrentCenter";
char *rg_kCurrentPoint = "rg_kCurrentPoint";
char *rg_kLastNumberOfTouches = "rg_kLastNumberOfTouches";


@interface UIGestureRecognizer (RGGestureHelpPrivate)

@property (nonatomic, assign) NSUInteger rg_lastNumberOfTouches;

/// 当前的第一个触摸点坐标
@property (nonatomic, assign) CGPoint rg_gestureCurrentPoint;

@end

@implementation UIGestureRecognizer (RGGestureHelpPrivate)

- (void)setRg_lastNumberOfTouches:(NSUInteger)rg_lastNumberOfTouches {
    objc_setAssociatedObject(self, rg_kLastNumberOfTouches, @(rg_lastNumberOfTouches), OBJC_ASSOCIATION_RETAIN);
}

- (NSUInteger)rg_lastNumberOfTouches {
    return [objc_getAssociatedObject(self, rg_kLastNumberOfTouches) unsignedIntValue];
}

- (void)setRg_gestureCurrentPoint:(CGPoint)rg_gestureCurrentPoint {
    objc_setAssociatedObject(self, rg_kCurrentPoint, @(rg_gestureCurrentPoint), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_gestureCurrentPoint {
    return [objc_getAssociatedObject(self, rg_kCurrentPoint) CGPointValue];
}

@end

@implementation UIGestureRecognizer (RGGestureHelp)

- (void)setRg_gestureOriginCenter:(CGPoint)rg_gestureOriginCenter {
    objc_setAssociatedObject(self, rg_kOriginCenter, @(rg_gestureOriginCenter), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_gestureOriginCenter {
    return [objc_getAssociatedObject(self, rg_kOriginCenter) CGPointValue];
}

- (void)setRg_gestureOriginSize:(CGSize)rg_gestureOriginSize {
    objc_setAssociatedObject(self, rg_kOriginSize, @(rg_gestureOriginSize), OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)rg_gestureOriginSize {
    return [objc_getAssociatedObject(self, rg_kOriginSize) CGSizeValue];
}

- (void)setRg_gestureOriginPoint:(CGPoint)rg_gestureOriginPoint {
    objc_setAssociatedObject(self, rg_kOriginPoint, @(rg_gestureOriginPoint), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_gestureOriginPoint {
    return [objc_getAssociatedObject(self, rg_kOriginPoint) CGPointValue];
}

- (void)setRg_gestureOriginPoints:(NSArray<NSNumber *> *)rg_gestureOriginPoints {
    objc_setAssociatedObject(self, rg_kOriginPoints, rg_gestureOriginPoints, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray<NSNumber *> *)rg_gestureOriginPoints {
    return objc_getAssociatedObject(self, rg_kOriginPoints);
}

- (void)setRg_gestureCurrentScale:(CGFloat)rg_gestureScale {
    objc_setAssociatedObject(self, rg_kScale, @(rg_gestureScale), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)rg_gestureCurrentScale {
    return [objc_getAssociatedObject(self, rg_kScale) floatValue];
}

- (void)setRg_gestureCurrentFingerCenter:(CGPoint)rg_gestureScaleCenter {
    objc_setAssociatedObject(self, rg_kScaleCenter, @(rg_gestureScaleCenter), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_gestureCurrentFingerCenter {
    return [objc_getAssociatedObject(self, rg_kScaleCenter) CGPointValue];
}

- (void)setRg_gestureCurrentCenter:(CGPoint)rg_gestureCurrentCenter {
    objc_setAssociatedObject(self, rg_kCurrentCenter, @(rg_gestureCurrentCenter), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)rg_gestureCurrentCenter {
    return [objc_getAssociatedObject(self, rg_kCurrentCenter) CGPointValue];
}

- (void)rg_eventValueChanged {
    switch (self.state) {
        case UIGestureRecognizerStateBegan: {
            
            self.rg_gestureOriginPoint = [self locationInView:self.view.superview];
            self.rg_gestureCurrentPoint = self.rg_gestureOriginPoint;
            
            self.rg_gestureOriginCenter = self.view.rg_centerInSuperView;
            self.rg_gestureOriginSize = self.view.frame.size;
            self.rg_gestureCurrentScale = 1;
            
            self.rg_gestureCurrentCenter = self.rg_gestureOriginCenter;
            
            NSUInteger touchCount = self.numberOfTouches;
            NSMutableArray *points = [NSMutableArray arrayWithCapacity:touchCount];
            for (NSUInteger i = 0; i < touchCount; i++) {
                [points addObject:@([self locationOfTouch:i inView:self.view.superview])];
            }
            self.rg_gestureOriginPoints = points;
            
            if (touchCount >= 2) {
                CGPoint p1 = [points[0] CGPointValue];
                CGPoint p2 = [points[1] CGPointValue];
                self.rg_gestureCurrentFingerCenter = CGPointMake((p1.x+p2.x)/2,(p1.y+p2.y)/2);
            } else {
                self.rg_gestureCurrentFingerCenter = self.rg_gestureOriginCenter;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSUInteger touchCount = self.numberOfTouches;
            
            CGPoint p = [self locationOfTouch:0 inView:self.view.superview];
            CGPoint o;
            {
                NSArray <NSNumber *> *points = self.rg_gestureOriginPoints;
                if (touchCount >= 2 && points.count >= 2) {
                    self.rg_gestureCurrentPoint = p;
                    CGPoint p1 = [self locationOfTouch:0 inView:self.view.superview];
                    CGPoint p2 = [self locationOfTouch:1 inView:self.view.superview];
                    
                    CGPoint q1 = points[0].CGPointValue;
                    CGPoint q2 = points[1].CGPointValue;
                    
                    o = self.rg_gestureCurrentFingerCenter;
                    p = CGPointMake((p1.x + p2.x) / 2,(p1.y + p2.y) / 2);
                    self.rg_gestureCurrentFingerCenter = p;
                    
                    CGFloat l1 = sqrt(pow(q1.x - q2.x, 2) + pow(q1.y - q2.y, 2));
                    CGFloat l2 = sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
                    
                    self.rg_gestureCurrentScale = l2 / l1;
                } else {
                    o = self.rg_gestureCurrentPoint;
                    self.rg_gestureCurrentPoint = p;
                }
            }
            if (touchCount != self.rg_lastNumberOfTouches) {
                break;
            }
            CGFloat dx = p.x - o.x;
            CGFloat dy = p.y - o.y;
            CGPoint currentCenter = self.rg_gestureCurrentCenter;
            
//            NSLog(@"[dx:%.3f dy:%.3f]", dx, dy);
            
            currentCenter.x += dx;
            currentCenter.y += dy;
            self.rg_gestureCurrentCenter = currentCenter;
        }
        default:
            break;
    }
    self.rg_lastNumberOfTouches = self.numberOfTouches;
}

@end
