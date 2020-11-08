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

@interface NSObject(RGGetSet)

- (void)rg_setValue:(nullable id)value forKey:(const NSString *)key retain:(BOOL)retain;
- (id)rg_valueForKey:(const NSString *)key;

- (void)rg_setValue:(nullable id)value forConstKey:(const char *)key retain:(BOOL)retain;
- (id)rg_valueforConstKey:(const char *)key;

/// 关联对象，通过这个方法会将 key 缓存起来，防止动态生成的 key 绑定对象后释放, 下次访问不到关联对象
- (void)rg_setValue:(nullable id)value forDynamicKey:(NSString *)key retain:(BOOL)retain;
- (id)rg_valueForDynamicKey:(NSString *)key;

/// 释放动态生成的 key, 调用后key的引用计数会-1, 当key的引用等于0时，会从缓存中移除
- (void)rg_releaseDynamicKeyIfNeed:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
