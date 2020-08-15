//
//  NSString+Compare.h
//  RGUIKit
//
//  Created by renge on 2018/11/21.
//  Copyright © 2018 ld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(RGCompare)

/// equal string
/// @param string string1
/// @param other string2
/// @discussion [nil, nil] -> YES; [nil, @"a"] -> NO; [@"a", nil] -> NO; [@"a" @"a"] -> YES; [@"a" @"b"] -> NO;
+ (BOOL)rg_equalString:(nullable NSString *)string toString:(nullable NSString *)other;

@end

NS_ASSUME_NONNULL_END
