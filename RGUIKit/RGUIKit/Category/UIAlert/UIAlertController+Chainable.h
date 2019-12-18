//
//  UIAlertController+Chainable.h
//  RGUIKit
//
//  Created by renge on 2019/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RGNewAlertController(title, msg, style) UIAlertController.rg_newAlert(title, msg, style)

typedef UIAlertController *_Nonnull(^RGAlertControlParam)(NSString * _Nullable title, NSString * _Nullable message, UIAlertControllerStyle style);

typedef UIAlertController *_Nonnull(^RGAlertActionParam)(NSString * _Nullable title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *action));
typedef UIAlertController *_Nonnull(^RGAlertTextFieldParam)(void (^_Nonnull handler)(UITextField *textField));

typedef UIAlertController *_Nonnull(^RGAlertActionParams)(NSString * _Nullable title, UIAlertActionStyle style, void (^_Nullable handler)(UIAlertAction *action, UIAlertController *alert));
typedef UIAlertController *_Nonnull(^RGAlertTextFieldParams)(void (^_Nonnull handler)(UITextField *textField, UIAlertController *alert));

@interface UIAlertController(Chainable)

@property (class, nonatomic, readonly) RGAlertControlParam rg_newAlert;

@property (nonatomic, readonly) RGAlertActionParam rg_addAction;
@property (nonatomic, readonly) RGAlertTextFieldParam rg_addTextField;

@property (nonatomic, readonly) RGAlertActionParams rg_addActionS;
@property (nonatomic, readonly) RGAlertTextFieldParams rg_addTextFieldS;

- (UIAlertController *(^)(UIView * _Nullable sourceView))rg_sourceView;
- (UIAlertController *(^)(CGRect sourceRect))rg_sourceRect;
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
