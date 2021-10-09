//
//  JHLinkTextView.m
//  XJCloud
//
//  Created by renge on 2020/10/17.
//  Copyright © 2020 ld. All rights reserved.
//

#import "RGLinkTextView.h"

@implementation RGLinkTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [UIMenuController sharedMenuController].menuVisible = NO;
    self.selectedRange = NSMakeRange(0, 0);
    return NO;
}

- (UITextRange *)selectedTextRange {
    return nil;
}

- (void)setSelectedRange:(NSRange)selectedRange {
    super.selectedRange = NSMakeRange(0, 0);
}

- (BOOL)canBecomeFocused {
    return NO;
}

@end
