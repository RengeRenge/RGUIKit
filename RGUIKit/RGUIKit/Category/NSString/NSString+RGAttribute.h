//
//  NSString+RGAttribute.h
//  XJCloud
//
//  Created by renge on 2020/11/17.
//  Copyright © 2020 ld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(RGAttribute)

- (NSMutableAttributedString *)rg_linkString;
- (NSMutableAttributedString *)rg_linkStringWithUnderline;

- (NSMutableAttributedString *)rg_colorStringWithDefaultColor:(UIColor *)defalutColor;


/// sample string: 12345 [color value=0xFFFFFF] 789 [/color] 999, pass [color] and [/color] to find 789
/// @param count match count
- (void)rg_findLabel:(NSString *)label
               count:(NSUInteger)count
              result:(void(NS_NOESCAPE^)(NSMutableString *str, NSMutableArray <NSValue *> *ranges, NSMutableArray <NSString *> *attributes))result;

@end

NS_ASSUME_NONNULL_END
