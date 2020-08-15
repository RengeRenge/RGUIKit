//
//  NSNull+Safe.m
//  RGUIKit
//
//  Created by renge on 2018/11/21.
//  Copyright © 2018 ld. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString(RGCompare)

+ (BOOL)rg_equalString:(NSString *)string toString:(NSString *)other {
    if (string == other) {
        return YES;
    }
    if (other && [string isEqualToString:other]) {
        return YES;
    }
    return NO;
}

@end
