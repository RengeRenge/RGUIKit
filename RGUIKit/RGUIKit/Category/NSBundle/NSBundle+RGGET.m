//
//  NSBundle+RGGET.m
//  XJAppCopy
//
//  Created by renge on 2021/3/24.
//

#import "NSBundle+RGGET.h"

@implementation NSBundle(RGGET)

+ (NSBundle *)rg_frameworkForClass:(Class)aClass {
    return [NSBundle bundleForClass:aClass];
}

+ (NSBundle *)rg_frameworkBundleForClass:(Class)aClass {
    return [self rg_bundleWithFramework:[NSBundle bundleForClass:aClass]];
}

+ (NSBundle *)rg_bundleWithFramework:(NSBundle *)bundle {
    if ([bundle.bundlePath hasSuffix:@".framework"]) {
        NSString *name = bundle.bundlePath.lastPathComponent.stringByDeletingPathExtension;
        NSString *bundlePath = [bundle pathForResource:name ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    return bundle;
}

@end
