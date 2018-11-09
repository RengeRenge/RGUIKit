//
//  NSObject+RGSwizzle.h
//  Pods-RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(RGSwizzle)

+ (void)rg_swizzleOriginalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel;

@end

NS_ASSUME_NONNULL_END
