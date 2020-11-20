//
//  NSObject+RGSwizzle.m
//  Pods-RGUIKitDemo
//
//  Created by renge on 2018/11/9.
//

#import "NSObject+RGRunTime.h"
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

static NSMutableArray *rg_keyCache;
static NSMutableDictionary *rg_keyCountMap;

static const char *rg_assoKeyCount = "rg_assoKeyCount";

@implementation NSObject(RGGetSet)

- (id)rg_valueForKey:(const NSString *)key {
    return [self rg_valueforConstKey:key.UTF8String];
}

- (id)rg_valueforConstKey:(const char *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)rg_setValue:(id)value forKey:(const NSString *)key retain:(BOOL)retain {
    [self rg_setValue:value forConstKey:key.UTF8String retain:retain];
}

- (void)rg_setValue:(id)value forConstKey:(nonnull const char *)key retain:(BOOL)retain {
    objc_AssociationPolicy policy = retain ? OBJC_ASSOCIATION_RETAIN:OBJC_ASSOCIATION_ASSIGN;
    objc_setAssociatedObject(self, key, value, policy);
}

- (id)rg_valueForDynamicKey:(NSString *)key {
    if (rg_keyCache) {
        NSUInteger index = [rg_keyCache indexOfObject:key];
        if (index != NSNotFound) {
            key = rg_keyCache[index];
        }
    }
    return [self rg_valueforConstKey:key.UTF8String];
}

- (void)rg_setValue:(id)value forDynamicKey:(NSString *)key retain:(BOOL)retain {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rg_keyCache = [NSMutableArray array];
        rg_keyCountMap = [NSMutableDictionary dictionary];
    });
    
    NSUInteger index = [rg_keyCache indexOfObject:key];
    if (index != NSNotFound) {
        key = rg_keyCache[index];
    } else {
        key = [key copy];
        [rg_keyCache addObject:key];
        index = rg_keyCache.count - 1;
    }
    
    NSUInteger count = [[key rg_valueforConstKey:rg_assoKeyCount] unsignedIntegerValue];
    id temp = [self rg_valueForKey:key];
    
    if (!temp && value) {
        count++;
        [key rg_setValue:@(count) forConstKey:rg_assoKeyCount retain:NO];
    } else if (temp && !value) {
        count--;
    }
    if (count == 0) {
        [rg_keyCache removeObjectAtIndex:index];
    }
    [self rg_setValue:value forConstKey:key.UTF8String retain:retain];
//    NSLog(@"set key:%@ Count:%lu", key, (unsigned long)count);
}

+ (void)rg_releaseDynamicKeyIfNeed:(NSString *)key {
    NSUInteger index = [rg_keyCache indexOfObject:key];
    if (index != NSNotFound) {
        key = rg_keyCache[index];
        NSUInteger count = [[key rg_valueforConstKey:rg_assoKeyCount] unsignedIntegerValue];
        count--;
        if (count <= 0) {
            [rg_keyCache removeObjectAtIndex:index];
        } else {
            [key rg_setValue:@(count) forConstKey:rg_assoKeyCount retain:NO];
        }
//        NSLog(@"release key:%lu", (unsigned long)count);
    }
//    NSLog(@"release key finish");
}

@end
