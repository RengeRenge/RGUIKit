//
//  UIAlertController+Chainable.m
//  RGUIKit
//
//  Created by renge on 2019/11/30.
//

#import "UIAlertController+Chainable.h"
#import "UIViewController+RGPresent.h"

@implementation UIAlertController (Chainable)

+ (RGAlertControlParamWithStyle)rg_newAlert {
    RGAlertControlParamWithStyle param = ^UIAlertController *(NSString * _Nullable title, NSString * _Nullable message, UIAlertControllerStyle style) {
        return [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    };
    return param;
}

+ (RGAlertControlAlertParam)rg_newActionAlert {
    RGAlertControlAlertParam param = ^UIAlertController *(NSString * _Nullable title, NSString * _Nullable message) {
        return [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    };
    return param;
}

+ (RGAlertControlSheetParam)rg_newActionSheet {
    RGAlertControlSheetParam param = ^UIAlertController *(NSString * _Nullable title, NSString * _Nullable message, id sourceView, CGRect sourceRect) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        return alert.rg_sourceView(sourceView).rg_sourceRect(sourceRect);
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

- (RGAlertActionParams)rg_addActionS {
    __weak typeof(self) wSelf = self;
    RGAlertActionParams param = ^UIAlertController *(NSString *title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *, UIAlertController *)) {
        [self addAction:[UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler(action, wSelf);
            }
        }]];
        return self;
    };
    return param;
}

- (RGAlertTextFieldParams)rg_addTextFieldS {
    __weak typeof(self) wSelf = self;
    RGAlertTextFieldParams param = ^UIAlertController *(void (^_Nullable handler)(UITextField *textField, UIAlertController *alert)) {
        [self addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (handler) {
                handler(textField, wSelf);
            }
        }];
        return self;
    };
    return param;
}

- (UIAlertController * _Nonnull (^)(id _Nullable))rg_sourceView {
    return ^UIAlertController * _Nonnull(id _Nullable sourceView) {
        if ([sourceView isKindOfClass:UIView.class]) {
            self.popoverPresentationController.sourceView = sourceView;
        } else if ([sourceView isKindOfClass:UIBarButtonItem.class]) {
            self.popoverPresentationController.barButtonItem = sourceView;
        }
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
        [viewController rg_topPresentViewController:self animated:YES completion:nil];
    };
}

@end
