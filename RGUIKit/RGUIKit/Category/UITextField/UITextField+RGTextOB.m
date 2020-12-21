//
//  UITextField+RGTextOB.m
//  RGUIKit
//
//  Created by renge on 2020/10/17.
//

#import "UITextField+RGTextOB.h"
#import "RGUIKit.h"
#import <RGRunTime/RGRunTime.h>

const NSString *rg_text_noti_key = @"rg_text_noti_key";

@interface RGUITextFieldNotiHandler : NSObject

@property (nonatomic, strong) id ob;

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) id <RGTextFieldDelegate> delegate;

@end

@implementation RGUITextFieldNotiHandler

- (void)setDelegate:(id<RGTextFieldDelegate>)delegate {
    _delegate = delegate;
    if (!_ob) {
        __weak typeof(self) wSelf = self;
        _ob = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:_textField queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [wSelf __rg_textFieldTextDidChange:note];
        }];
    }
}

- (void)__rg_textFieldTextDidChange:(NSNotification *)notification {
    if (_delegate && [_delegate respondsToSelector:@selector(textField:textDidChange:)]) {
        [_delegate textField:_textField textDidChange:_textField.text];
    }
}

- (void)dealloc {
    if (_ob) {
        [[NSNotificationCenter defaultCenter] removeObserver:_ob];
        _ob = nil;
    }
}

@end

@implementation UITextField(RGTextOB)

- (void)setRg_delegate:(id<RGTextFieldDelegate>)rg_delegate {
    RGUITextFieldNotiHandler *ob = [self rg_valueForKey:rg_text_noti_key];
    if (!ob) {
        ob = [RGUITextFieldNotiHandler new];
        ob.textField = self;
    }
    ob.delegate = rg_delegate;
    [self rg_setValue:ob forKey:rg_text_noti_key retain:YES];
}

- (id<RGTextFieldDelegate>)rg_delegate {
    RGUITextFieldNotiHandler *ob = [self rg_valueForKey:rg_text_noti_key];
    return ob.delegate;
}

@end
