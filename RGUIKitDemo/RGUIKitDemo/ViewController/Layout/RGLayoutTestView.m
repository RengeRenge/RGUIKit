//
//  RGLayoutTestView.m
//  RGUIKitDemo
//
//  Created by renge on 2020/12/3.
//  Copyright © 2020 ld. All rights reserved.
//

#import "RGLayoutTestView.h"
#import <RGUIKit/RGUIKit.h>

@implementation RGLayoutTestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _leadingView = [UIView new];
        _leadingView.backgroundColor = UIColor.cyanColor;
        [self addSubview:_leadingView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    RGLayout.shared.targetNext(_leadingView, self.bounds)
    .sizeMake(20, 20).centerYIn(self.bounds).leading(0).apply();
}

@end
