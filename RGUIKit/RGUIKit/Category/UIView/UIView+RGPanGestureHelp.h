//
//  UIView+PanGestureHelp.h
//  CampTalk
//
//  Created by renge on 2018/4/28.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RGPanGestureHelp)

@property (nonatomic, assign) CGPoint rg_originCenter;
@property (nonatomic, assign) CGSize rg_originSize;
@property (nonatomic, assign) CGPoint rg_startPoint;

- (void)rg_startWithPoint:(CGPoint)startPoint;

- (void)rg_updateCenterWithNewPoint:(CGPoint)newPoint;

- (void)rg_centerScale:(CGFloat)scale;

@end
