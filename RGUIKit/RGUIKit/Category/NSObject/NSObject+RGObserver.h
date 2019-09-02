//
//  NSObject+RGObserver.h
//  RGUIKit
//
//  Created by renge on 2019/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(RGObserver)

/**
 auto remove KVO when dealloc
 */
- (void)rg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;


/**
 remove KVO
 */
- (void)rg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
