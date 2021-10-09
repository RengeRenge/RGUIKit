//
//  NSBundle+RGGET.h
//  XJAppCopy
//
//  Created by renge on 2021/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle(RGGET)

+ (NSBundle *)rg_frameworkForClass:(Class)aClass;
+ (NSBundle *)rg_frameworkBundleForClass:(Class)aClass;

+ (NSBundle *)rg_bundleWithFramework:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
