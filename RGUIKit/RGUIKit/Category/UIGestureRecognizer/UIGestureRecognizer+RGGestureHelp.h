//
//  UIGestureRecognizer+RGGestureHelp.h
//  CampTalk
//
//  Created by renge on 2018/4/28.
//  Copyright © 2018年 yuru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (RGGestureHelp)

/// 初始位置的视图中心点
@property (nonatomic, assign) CGPoint rg_gestureOriginCenter;

/// 初始的视图大小
@property (nonatomic, assign) CGSize rg_gestureOriginSize;

/// 初始的第一个触摸点坐标
@property (nonatomic, assign) CGPoint rg_gestureOriginPoint;

/// 初始的所有触摸点坐标
@property (nonatomic, strong) NSArray <NSNumber *> *rg_gestureOriginPoints;

/// 当前前2个触摸点的中心位置
@property (nonatomic, assign) CGPoint rg_gestureCurrentFingerCenter;

/// 当前前2个触摸点的距离与初始位置前2个触摸点的距离的比值
@property (nonatomic, assign) CGFloat rg_gestureCurrentScale;

/// 当前手势给予视图的推荐中心点
@property (nonatomic, assign) CGPoint rg_gestureCurrentCenter;

- (void)rg_eventValueChanged;

@end
