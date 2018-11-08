//
//  UIView+JTParentVC.m
//  JusTalk
//
//  Created by 姜豪 on 19/12/2017.
//  Copyright © 2017 juphoon. All rights reserved.
//

#import "UIView+RGParentVC.h"

@implementation UIView (RGParentVC)

- (UIViewController *)rg_parentViewController {
    
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}


@end
