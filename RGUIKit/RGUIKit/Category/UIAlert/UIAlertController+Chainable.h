//
//  UIAlertController+Chainable.h
//  RGUIKit
//
//  Created by renge on 2019/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RGNewAlertController(title, msg, style) UIAlertController.rg_newAlert(title, msg, style)

typedef UIAlertController *_Nonnull(^RGAlertControlParamWithStyle)(NSString * _Nullable title, NSString * _Nullable message, UIAlertControllerStyle style);
typedef UIAlertController *_Nonnull(^RGAlertControlAlertParam)(NSString * _Nullable title, NSString * _Nullable message);
typedef UIAlertController *_Nonnull(^RGAlertControlSheetParam)(NSString * _Nullable title, NSString * _Nullable message, id sourceView, CGRect sourceRect);
typedef UIAlertController *_Nonnull(^RGAlertControlAttributedStringParam)(NSAttributedString * _Nullable message);

typedef UIAlertController *_Nonnull(^RGAlertActionParam)(NSString * _Nullable title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *action));
typedef UIAlertController *_Nonnull(^RGAlertTextFieldParam)(void (^_Nonnull handler)(UITextField *textField));

typedef UIAlertController *_Nonnull(^RGAlertActionParams)(NSString * _Nullable title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *action, UIAlertController *alert));
typedef UIAlertController *_Nonnull(^RGAlertTextFieldParams)(void (^_Nonnull handler)(UITextField *textField, UIAlertController *alert));

@interface UIAlertController(Chainable)

@property (class, nonatomic, readonly) RGAlertControlParamWithStyle rg_newAlert;

@property (class, nonatomic, readonly) RGAlertControlSheetParam rg_newActionSheet;
@property (class, nonatomic, readonly) RGAlertControlAlertParam rg_newActionAlert;

@property (nonatomic, readonly) RGAlertActionParam rg_addAction;
@property (nonatomic, readonly) RGAlertTextFieldParam rg_addTextField;

@property (nonatomic, readonly) RGAlertActionParams rg_addActionS;
@property (nonatomic, readonly) RGAlertTextFieldParams rg_addTextFieldS;

@property (nonatomic, readonly) RGAlertControlAttributedStringParam rg_attributeMessage;

/// must set for iPad when UIAlertControllerStyle is UIAlertControllerStyleActionSheet, sourceView can be UIView or UIBarButtonItem
- (UIAlertController *(^)(id _Nullable sourceView))rg_sourceView;

/// must set for iPad when UIAlertControllerStyle is UIAlertControllerStyleActionSheet
- (UIAlertController *(^)(CGRect sourceRect))rg_sourceRect;

/// be presented with viewController
- (void(^)(UIViewController *viewController))rg_presentedBy;

@end


NS_ASSUME_NONNULL_END

/* Usage
 
 RGNewAlertController(@"213", nil, UIAlertControllerStyleAlert)
 .rg_addAction(@"123", UIAlertActionStyleDefault, ^(UIAlertAction *action){
     
 }).rg_addAction(@"123", UIAlertActionStyleDefault, ^(UIAlertAction *action){
     
 }).rg_addAction(@"123", UIAlertActionStyleDefault, ^(UIAlertAction *action){
     
 }).rg_addAction(@"123", UIAlertActionStyleDefault, ^(UIAlertAction *action){
     
 }).rg_addTextField(^(UITextField *textField) {
     
 }).rg_sourceView(self.view).rg_sourceRect(self.view.bounds).rg_presentedBy(self);
 
 */
