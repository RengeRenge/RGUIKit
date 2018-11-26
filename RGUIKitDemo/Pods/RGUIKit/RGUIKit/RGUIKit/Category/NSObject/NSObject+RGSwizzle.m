//
//  NSObject+RGSwizzle.m
//  Pods-RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//

#import "NSObject+RGSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject(RGSwizzle)

+ (void)rg_swizzleOriginalSel:(SEL)originalSel swizzledSel:(SEL)swizzledSel {
    Class selfClass = [self class];
    Method originalMethod = class_getInstanceMethod(selfClass, originalSel);
    Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSel);
    
    BOOL didAddMethod =
    class_addMethod(selfClass,
                    originalSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(selfClass,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
