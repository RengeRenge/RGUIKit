//
//  UIAlertController+RGConfig.m
//  RGUIKit
//
//  Created by renge on 2019/11/30.
//

#import "UIAlertController+Chainable.h"

@implementation UIAlertController (Chainable)

+ (RGAlertControlParam)rg_newAlert {
    RGAlertControlParam param = ^UIAlertController *(NSString * _Nullable title, NSString * _Nullable message, UIAlertControllerStyle style) {
        return [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    };
    return param;
}

- (RGAlertActionParam)rg_addAction {
    RGAlertActionParam param = ^UIAlertController *(NSString *title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *)) {
        [self addAction:[UIAlertAction actionWithTitle:title style:style handler:handler]];
        return self;
    };
    return param;
}

- (RGAlertTextFieldParam)rg_addTextField {
    RGAlertTextFieldParam param = ^UIAlertController *(void (^_Nullable handler)(UITextField *textField)) {
        [self addTextFieldWithConfigurationHandler:handler];
        return self;
    };
    return param;
}

- (UIAlertController * _Nonnull (^)(UIView * _Nullable))rg_sourceView {
    return ^UIAlertController * _Nonnull(UIView * _Nullable sourceView) {
        self.popoverPresentationController.sourceView = sourceView;
        return self;
    };
}

- (UIAlertController *(^)(CGRect sourceRect))rg_sourceRect {
    return ^UIAlertController * _Nonnull(CGRect sourceRect) {
        self.popoverPresentationController.sourceRect = sourceRect;
        return self;
    };
}

- (void (^)(UIViewController * _Nonnull viewController))rg_presentedBy {
    return ^(UIViewController * _Nonnull viewController) {
        [viewController presentViewController:self animated:YES completion:nil];
    };
}

@end
