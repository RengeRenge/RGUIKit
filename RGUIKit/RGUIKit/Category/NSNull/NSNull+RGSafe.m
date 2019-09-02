//
//  NSNull+Safe.m
//  RGUIKit
//
//  Created by renge on 2018/11/21.
//  Copyright © 2018 ld. All rights reserved.
//

#import "NSNull+RGSafe.h"

@implementation NSNull(RGSafe)

- (nullable id)objectForKeyedSubscript:(id)key {
    return nil;
}

- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx {
    return nil;
}

- (BOOL)isEqualToString:(NSString *)aString {
    if (aString == nil) {
        return YES;
    }
    return NO;
}

- (NSUInteger)count {
    return 0;
}

- (NSUInteger)length {
    return 0;
}

@end
